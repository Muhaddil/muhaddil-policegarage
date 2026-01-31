let vehiclesData = [];
let favoritesData = [];
let vehicleConfigsData = {};
let currentFilter = 'all';
let currentCategory = 'all';
let selectedVehicle = null;
let currentCustomization = {
    primaryColor: null,
    secondaryColor: null,
    livery: 0,
    extras: {}
};

function loadFromLocalStorage() {
    const savedFavorites = localStorage.getItem('policegarage_favorites');
    const savedConfigs = localStorage.getItem('policegarage_configs');

    if (savedFavorites) {
        try {
            favoritesData = JSON.parse(savedFavorites);
        } catch (e) {
            favoritesData = [];
        }
    }

    if (savedConfigs) {
        try {
            vehicleConfigsData = JSON.parse(savedConfigs);
        } catch (e) {
            vehicleConfigsData = {};
        }
    }
}

function saveToLocalStorage() {
    localStorage.setItem('policegarage_favorites', JSON.stringify(favoritesData));
    localStorage.setItem('policegarage_configs', JSON.stringify(vehicleConfigsData));
}

window.addEventListener('message', function (event) {
    const data = event.data;

    if (data.action === 'openGarage') {
        openGarage(data);
    } else if (data.action === 'closeGarage') {
        closeGarage();
    }

    if (data.action === 'vehicleGameData') {
        const vehicle = vehiclesData.find(v => v.model === data.model);
        if (!vehicle) return;

        vehicle.liveries = data.liveries;
        vehicle.extras = data.extras;
        vehicle.stats = data.stats;
        vehicle.seats = data.seats;

        if (selectedVehicle && selectedVehicle.model === data.model) {
            renderCustomization();
            updatePreview();
        }
    }
});

document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') {
        closeUI();
    }
});

function openGarage(data) {
    loadFromLocalStorage();

    vehiclesData = data.vehicles;

    document.getElementById('app').style.display = 'flex';
    document.getElementById('garageName').textContent = data.garage.name;
    document.getElementById('totalVehicles').textContent = vehiclesData.length;
    document.getElementById('favoriteCount').textContent = favoritesData.length;

    renderCategories();
    renderVehicleList();
    setupEventListeners();
}

function closeGarage() {
    document.getElementById('app').style.display = 'none';
    selectedVehicle = null;
    currentCustomization = {
        primaryColor: null,
        secondaryColor: null,
        livery: 0,
        extras: {}
    };
}

function renderCategories() {
    const categories = [...new Set(vehiclesData.map(v => v.category))];
    const container = document.getElementById('categoryFilters');

    container.innerHTML = `
        <button class="category-btn active" data-category="all">Todos</button>
        ${categories.map(cat => `
            <button class="category-btn" data-category="${cat}">${cat}</button>
        `).join('')}
    `;

    container.querySelectorAll('.category-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            currentCategory = btn.dataset.category;
            container.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            renderVehicleList();
        });
    });
}

function renderVehicleList() {
    const container = document.getElementById('vehicleList');

    let filtered = vehiclesData;

    if (currentFilter === 'favorites') {
        filtered = filtered.filter(v => favoritesData.includes(v.model));
    }

    if (currentCategory !== 'all') {
        filtered = filtered.filter(v => v.category === currentCategory);
    }

    container.innerHTML = filtered.map(vehicle => {
        const isFavorite = favoritesData.includes(vehicle.model);
        const isSelected = selectedVehicle && selectedVehicle.model === vehicle.model;

        return `
            <div class="vehicle-card ${isSelected ? 'selected' : ''} ${isFavorite ? 'favorite' : ''}" 
                 data-model="${vehicle.model}">
                <div class="vehicle-name">${vehicle.name}</div>
                <span class="vehicle-category">${vehicle.category}</span>
            </div>
        `;
    }).join('');

    container.querySelectorAll('.vehicle-card').forEach(card => {
        card.addEventListener('click', () => {
            const model = card.dataset.model;
            selectVehicle(model);
        });
    });
}

function selectVehicle(model) {
    selectedVehicle = vehiclesData.find(v => v.model === model);
    if (!selectedVehicle) return;

    renderVehicleList();
    renderCustomization();

    document.getElementById('spawnBtn').disabled = false;

    if (vehicleConfigsData[model]) {
        currentCustomization = vehicleConfigsData[model];
    } else {
        currentCustomization = {
            primaryColor: selectedVehicle.colors[0].primary,
            secondaryColor: selectedVehicle.colors[0].secondary,
            livery: 0,
            extras: {}
        };

        if (selectedVehicle.defaultExtras) {
            selectedVehicle.defaultExtras.forEach(extra => {
                currentCustomization.extras[extra] = true;
            });
        }
    }

    updatePreview();

    fetch(`https://${GetParentResourceName()}/previewVehicle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ model, config: currentCustomization })
    }).catch(() => {});
}

function updatePreview() {
    if (!selectedVehicle) return;

    document.getElementById('previewName').textContent = selectedVehicle.name;
    document.getElementById('previewCategory').textContent = selectedVehicle.category;
    document.getElementById('previewModel').textContent = selectedVehicle.model.toUpperCase();

    const favoriteBtn = document.getElementById('toggleFavorite');
    favoriteBtn.classList.toggle('active', favoritesData.includes(selectedVehicle.model));

    if (!selectedVehicle.stats) {
        updateStat('speed', 0);
        updateStat('accel', 0);
        updateStat('handling', 0);
        updateStat('braking', 0);
        document.getElementById('capacityValue').textContent = '-';
        return;
    }

    const stats = selectedVehicle.stats;
    updateStat('speed', stats.speed || 0);
    updateStat('accel', stats.acceleration || 0);
    updateStat('handling', stats.handling || 0);
    updateStat('braking', stats.braking || 0);

    document.getElementById('capacityValue').textContent = selectedVehicle.seats || '-';
}

function updateStat(statName, value) {
    const bar = document.getElementById(`${statName}Bar`);
    const valueEl = document.getElementById(`${statName}Value`);

    bar.style.width = `${value}%`;
    valueEl.textContent = value;
}

function renderCustomization() {
    if (!selectedVehicle) return;

    renderColors();
    renderLiveries();
    renderExtras();
}


function getGTAVColorRGB(colorId) {
    const gtaColors = {
        0: '#0d1116', 1: '#1c1d21', 2: '#32383d', 3: '#454b4f', 4: '#999da0',
        11: '#1e2429', 12: '#35363a', 24: '#6c4f40', 27: '#c00e1a', 28: '#da1918',
        29: '#b6111b', 30: '#a51e23', 31: '#7b1a22', 32: '#8e1b1f', 33: '#6f1818',
        34: '#49111d', 35: '#b60f25', 36: '#d44a17', 37: '#c2944f', 38: '#f78616',
        49: '#155c2d', 50: '#1b6770', 51: '#66b81f', 52: '#22383e', 53: '#1d5a3f',
        54: '#2d423f', 55: '#45594b', 64: '#0b9cf1', 65: '#2f2519', 66: '#2354a1',
        67: '#6ea3c6', 68: '#112552', 69: '#1b203e', 70: '#275190', 73: '#47578f',
        88: '#ffc909', 89: '#fec70e', 90: '#d6e665', 91: '#4e6443', 92: '#f7b833',
        96: '#9c9c9c', 111: '#f0f0f0', 112: '#fafffa', 113: '#fafbf6',
        134: '#f21f99', 135: '#fdd6cd', 136: '#df5891', 137: '#f6ae20',
        138: '#b0ab94', 141: '#9f9e8a', 142: '#621276', 143: '#0b0d10',
        144: '#2f2d52', 145: '#7f6a48', 158: '#a0774e'
    };
    return gtaColors[colorId] || '#cccccc';
}

function renderColors() {
    const container = document.getElementById('colorSelector');

    container.innerHTML = selectedVehicle.colors.map((color, index) => {
        const primaryColor = getGTAVColorRGB(color.primary);
        const secondaryColor = getGTAVColorRGB(color.secondary);

        return `
            <div class="color-option ${currentCustomization.primaryColor === color.primary ? 'selected' : ''}" 
                 data-index="${index}"
                 style="background: linear-gradient(135deg, ${primaryColor}, ${secondaryColor});"
                 title="${color.name}">
            </div>
        `;
    }).join('');

    container.querySelectorAll('.color-option').forEach(option => {
        option.addEventListener('click', () => {
            const index = parseInt(option.dataset.index);
            const color = selectedVehicle.colors[index];

            currentCustomization.primaryColor = color.primary;
            currentCustomization.secondaryColor = color.secondary;

            renderColors();
            updateVehiclePreview();
            saveVehicleConfig();
        });
    });
}
function renderLiveries() {
    const container = document.getElementById('liverySelector');

    if (!selectedVehicle.liveries || selectedVehicle.liveries.length === 0) {
        container.innerHTML = '<p style="color: var(--text-secondary); font-size: 12px;">No hay liveries disponibles</p>';
        return;
    }

    container.innerHTML = selectedVehicle.liveries.map(livery => `
        <div class="livery-option ${currentCustomization.livery === livery ? 'selected' : ''}" 
             data-livery="${livery}">
            Livery ${livery + 1}
        </div>
    `).join('');

    container.querySelectorAll('.livery-option').forEach(option => {
        option.addEventListener('click', () => {
            currentCustomization.livery = parseInt(option.dataset.livery);
            renderLiveries();
            updateVehiclePreview();
            saveVehicleConfig();
        });
    });
}

function renderExtras() {
    const container = document.getElementById('extrasList');

    if (!selectedVehicle.extras || selectedVehicle.extras.length === 0) {
        container.innerHTML = '<p style="color: var(--text-secondary); font-size: 12px;">No hay extras disponibles</p>';
        return;
    }

    container.innerHTML = selectedVehicle.extras.map(extra => {
        const isActive = currentCustomization.extras[extra] === true;

        return `
            <div class="extra-option ${isActive ? 'active' : ''}" data-extra="${extra}">
                <span>Extra ${extra}</span>
                <div class="extra-checkbox"></div>
            </div>
        `;
    }).join('');

    container.querySelectorAll('.extra-option').forEach(option => {
        option.addEventListener('click', () => {
            const extra = parseInt(option.dataset.extra);

            if (currentCustomization.extras[extra]) {
                delete currentCustomization.extras[extra];
            } else {
                currentCustomization.extras[extra] = true;
            }

            renderExtras();
            updateVehiclePreview();
            saveVehicleConfig();
        });
    });
}

function updateVehiclePreview() {
    if (!selectedVehicle) return;

    fetch(`https://${GetParentResourceName()}/previewVehicle`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            model: selectedVehicle.model,
            config: currentCustomization
        })
    }).catch(err => console.log('Preview update error:', err));
}

function saveVehicleConfig() {
    if (!selectedVehicle) return;

    vehicleConfigsData[selectedVehicle.model] = currentCustomization;
    saveToLocalStorage();
}

function setupEventListeners() {
    document.getElementById('closeBtn').addEventListener('click', closeUI);

    document.querySelectorAll('.filter-tab').forEach(tab => {
        tab.addEventListener('click', () => {
            currentFilter = tab.dataset.filter;
            document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            renderVehicleList();
        });
    });

    document.getElementById('toggleFavorite').addEventListener('click', toggleFavorite);

    document.getElementById('spawnBtn').addEventListener('click', spawnVehicle);

    document.getElementById('resetBtn').addEventListener('click', resetCustomization);
}

function toggleFavorite() {
    if (!selectedVehicle) return;

    const index = favoritesData.indexOf(selectedVehicle.model);

    if (index > -1) {
        favoritesData.splice(index, 1);
    } else {
        favoritesData.push(selectedVehicle.model);
    }

    document.getElementById('favoriteCount').textContent = favoritesData.length;

    updatePreview();
    renderVehicleList();

    saveToLocalStorage();
}

function spawnVehicle() {
    if (!selectedVehicle) return;

    fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            model: selectedVehicle.model,
            config: currentCustomization
        })
    }).catch(err => console.log('Spawn error:', err));
}

function resetCustomization() {
    if (!selectedVehicle) return;

    currentCustomization = {
        primaryColor: selectedVehicle.colors[0].primary,
        secondaryColor: selectedVehicle.colors[0].secondary,
        livery: 0,
        extras: {}
    };

    if (selectedVehicle.defaultExtras) {
        selectedVehicle.defaultExtras.forEach(extra => {
            currentCustomization.extras[extra] = true;
        });
    }

    renderCustomization();
    updateVehiclePreview();
    saveVehicleConfig();
}

function closeUI() {
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).catch(err => console.log('Close error:', err));
}