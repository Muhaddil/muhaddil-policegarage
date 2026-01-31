Config = {}

Config.FrameWork = "auto" -- auto, esx, qb
Config.ESXVer = "new"     -- new, old
Config.UseOXNotifications = true

Config.GarageLocations = {
    {
        name = "Garaje LSPD Mission Row",
        coords = vector3(452.11, -1017.86, 28.48),
        heading = 90.0,
        blip = false,
        job = { "police", "sheriff", "statepolice" },
        spawnPoint = vector4(438.42, -1018.30, 27.75, 90.0)
    },
    {
        name = "Garaje LSPD Sandy Shores",
        coords = vector3(1853.16, 3686.93, 34.27),
        heading = 210.0,
        blip = false,
        job = { "police", "sheriff", "statepolice" },
        spawnPoint = vector4(1868.09, 3696.37, 33.55, 210.0)
    },
    {
        name = "Garaje LSPD Paleto Bay",
        coords = vector3(-475.43, 6026.13, 31.34),
        heading = 315.0,
        blip = false,
        job = "police",
        spawnPoint = vector4(-469.68, 6031.29, 31.34, 315.0)
    }
}

Config.PlaterPerJob = {
    ["police"] = 'LSPD',
    ["sheriff"] = 'BCSO',
    ["statepolice"] = 'STATE'
}

Config.Vehicles = {
    {
        model = "nkcruiser",
        name = "Police Cruiser",
        category = "Patrulla",
        price = 0, -- Gratis para policías
        colors = {
            { name = "Blanco/Negro",   primary = 0, secondary = 111 },
            { name = 'Blanco',      primary = 111, secondary = 111 },
            { name = 'Negro',       primary = 0,   secondary = 0 },
            { name = 'Azul',        primary = 64,  secondary = 64 },
            { name = 'Rojo',        primary = 27,  secondary = 27 },
            { name = 'Verde',       primary = 49,  secondary = 49 },
            { name = 'Amarillo',    primary = 88,  secondary = 88 },
            { name = 'Naranja',     primary = 38,  secondary = 38 },
            { name = 'Rosa',        primary = 135, secondary = 135 },
            { name = 'Morado',      primary = 142, secondary = 142 },
            { name = 'Gris Oscuro', primary = 12,  secondary = 12 },
            { name = 'Gris Claro',  primary = 111, secondary = 111 },
            { name = 'Cian',        primary = 96,  secondary = 96 },
            { name = 'Marrón',      primary = 24,  secondary = 24 },
            { name = 'Dorado',      primary = 158, secondary = 158 },
        },
        seats = 4
    },
    {
        model = "police2",
        name = "Police Buffalo",
        category = "Patrulla",
        price = 0,
        liveries = { 0, 1, 2 },
        extras = { 1, 2, 3, 4, 5, 6, 7, 8 },
        defaultExtras = { 1, 2 },
        colors = {
            { name = "Blanco/Negro",   primary = 111, secondary = 0 },
            { name = "Negro Completo", primary = 0,   secondary = 0 },
            { name = "Gris Metálico",  primary = 4,   secondary = 0 },
        },
        stats = {
            speed = 85,
            acceleration = 80,
            handling = 80,
            braking = 75
        },
        seats = 4
    },
    {
        model = "police3",
        name = "Police Interceptor",
        category = "Patrulla",
        price = 0,
        liveries = { 0, 1, 2, 3 },
        extras = { 1, 2, 3, 4, 5, 6, 7 },
        defaultExtras = { 1, 2 },
        colors = {
            { name = "Blanco/Negro", primary = 111, secondary = 0 },
            { name = "Negro/Blanco", primary = 0,   secondary = 111 },
            { name = "Azul Marino",  primary = 64,  secondary = 0 },
        },
        stats = {
            speed = 90,
            acceleration = 85,
            handling = 85,
            braking = 80
        },
        seats = 4
    },

    -- VEHÍCULOS SUV
    {
        model = "police4",
        name = "Police SUV",
        category = "SUV",
        price = 0,
        liveries = { 0, 1, 2 },
        extras = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
        defaultExtras = { 1, 2, 5 },
        colors = {
            { name = "Blanco/Negro",   primary = 111, secondary = 0 },
            { name = "Negro Completo", primary = 0,   secondary = 0 },
            { name = "Gris Oscuro",    primary = 4,   secondary = 4 },
        },
        stats = {
            speed = 70,
            acceleration = 65,
            handling = 70,
            braking = 75
        },
        seats = 6
    },
    {
        model = "fbi2",
        name = "FBI SUV",
        category = "SUV",
        price = 0,
        liveries = { 0, 1 },
        extras = { 1, 2, 3, 4, 5, 6 },
        defaultExtras = { 1, 2 },
        colors = {
            { name = "Negro Oficial", primary = 0, secondary = 0 },
            { name = "Gris Oscuro",   primary = 4, secondary = 4 },
        },
        stats = {
            speed = 75,
            acceleration = 70,
            handling = 75,
            braking = 80
        },
        seats = 6
    },

    -- VEHÍCULOS TÁCTICOS
    {
        model = "riot",
        name = "Police Riot",
        category = "Táctico",
        price = 0,
        liveries = { 0 },
        extras = { 1, 2, 3, 4, 5 },
        defaultExtras = { 1 },
        colors = {
            { name = "Negro Táctico", primary = 0, secondary = 0 },
        },
        stats = {
            speed = 60,
            acceleration = 55,
            handling = 60,
            braking = 70
        },
        seats = 8
    },
    {
        model = "policet",
        name = "Police Transporter",
        category = "Táctico",
        price = 0,
        liveries = { 0 },
        extras = { 1, 2, 3, 4, 5, 6 },
        defaultExtras = { 1, 2 },
        colors = {
            { name = "Blanco/Azul",  primary = 111, secondary = 64 },
            { name = "Blanco/Negro", primary = 111, secondary = 0 },
        },
        stats = {
            speed = 65,
            acceleration = 60,
            handling = 65,
            braking = 75
        },
        seats = 6
    },

    -- MOTOCICLETAS
    {
        model = "policeb",
        name = "Police Bike",
        category = "Moto",
        price = 0,
        liveries = { 0, 1, 2 },
        extras = { 1, 2 },
        defaultExtras = { 1 },
        colors = {
            { name = "Blanco/Negro", primary = 111, secondary = 0 },
            { name = "Negro/Blanco", primary = 0,   secondary = 111 },
        },
        stats = {
            speed = 95,
            acceleration = 90,
            handling = 90,
            braking = 85
        },
        seats = 2
    },

    -- VEHÍCULOS ESPECIALES
    -- {
    --     model = "polmav",
    --     name = "Police Maverick",
    --     category = "Aéreo",
    --     price = 0,
    --     liveries = { 0 },
    --     extras = { 1, 2, 3 },
    --     defaultExtras = { 1 },
    --     colors = {
    --         { name = "Blanco/Negro", primary = 111, secondary = 0 },
    --     },
    --     stats = {
    --         speed = 85,
    --         acceleration = 75,
    --         handling = 70,
    --         braking = 65
    --     },
    --     seats = 6
    -- },
    {
        model = "predator",
        name = "Police Predator",
        category = "Acuático",
        price = 0,
        liveries = { 0 },
        extras = { 1, 2 },
        defaultExtras = { 1 },
        colors = {
            { name = "Blanco/Negro", primary = 111, secondary = 0 },
        },
        stats = {
            speed = 80,
            acceleration = 70,
            handling = 75,
            braking = 70
        },
        seats = 4
    },

    -- VEHÍCULOS UNMARKED
    {
        model = "fbi",
        name = "Unmarked Cruiser",
        category = "Encubierto",
        price = 0,
        liveries = { 0, 1 },
        extras = { 1, 2, 3, 4 },
        defaultExtras = {},
        colors = {
            { name = "Negro",       primary = 0,   secondary = 0 },
            { name = "Gris Oscuro", primary = 4,   secondary = 4 },
            { name = "Azul Marino", primary = 64,  secondary = 64 },
            { name = "Blanco",      primary = 111, secondary = 111 },
        },
        stats = {
            speed = 88,
            acceleration = 85,
            handling = 85,
            braking = 80
        },
        seats = 4
    },
}

Config.Blip = {
    sprite = 56,
    color = 3,
    scale = 0.8,
    name = "Garaje Policial"
}

Config.InteractionDistance = 2.5
Config.OpenKey = 38

Config.RotationSpeed = 0.1
Config.PreviewZone = {
    coords = vector4(1000.0, -3000.0, -40.0, 180.0) -- bajo el mapa, zona vacía
}
