local isInGarageZone = false
local currentGarage = nil
local nuiOpen = false
local previewVehicle = nil
local previewCamera = nil

Citizen.CreateThread(function()
    for k, garage in pairs(Config.GarageLocations) do
        if garage.blip then
            local blip = AddBlipForCoord(garage.coords.x, garage.coords.y, garage.coords.z)
            SetBlipSprite(blip, Config.Blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.Blip.scale)
            SetBlipColour(blip, Config.Blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(garage.name)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

local garageStates = {}

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for k, garage in pairs(Config.GarageLocations) do
            local distance = #(playerCoords - garage.coords)

            if garageStates[k] == nil then
                garageStates[k] = false
            end

            if distance < Config.InteractionDistance then
                sleep = 0
                DrawMarker(
                    20,
                    garage.coords.x, garage.coords.y, garage.coords.z,
                    0, 0, 0,
                    0, 0, 0,
                    1.0, 1.0, 1.0,
                    0, 150, 255, 100,
                    false, true, 2, false, nil, nil, false
                )

                if not garageStates[k] then
                    lib.showTextUI('[E] - Abrir Garaje Policial')
                    garageStates[k] = true
                    currentGarage = garage
                end

                if IsControlJustReleased(0, Config.OpenKey) then
                    if not CanPlayerUseGarage(garage) then
                        ShowNotification("No tienes acceso a este garaje", "error", 3000)
                        return
                    end

                    local ped = PlayerPedId()

                    if IsPedInAnyVehicle(ped, false) then
                        local vehicle = GetVehiclePedIsIn(ped, false)

                        if GetPedInVehicleSeat(vehicle, -1) == ped then
                            StoreVehicle(vehicle, garage)
                        else
                            ShowNotification("Debes ser el conductor", "error", 3000)
                        end
                    else
                        OpenGarage(garage)
                    end
                end
            end

            if garageStates[k] and distance > Config.InteractionDistance then
                lib.hideTextUI()
                garageStates[k] = false
                if not nuiOpen then
                    currentGarage = nil
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

function OpenGarage(garage)
    if nuiOpen then return end

    nuiOpen = true
    currentGarage = garage

    SetNuiFocus(true, true)

    SendNUIMessage({
        action = "openGarage",
        vehicles = Config.Vehicles,
        garage = {
            name = garage.name,
            location = garage.coords
        }
    })

    FreezeEntityPosition(PlayerPedId(), true)
    -- CreatePreviewCamera()
end

function CloseGarage()
    if not nuiOpen then return end

    nuiOpen = false
    SetNuiFocus(false, false)

    SendNUIMessage({ action = "closeGarage" })

    FreezeEntityPosition(PlayerPedId(), false)

    DestroyPreviewVehicle(previewVehicle)
    DestroyPreviewCamera()

    currentGarage = nil
end

function PositionPreviewCamera(vehicle)
    local minDim, maxDim = GetModelDimensions(GetEntityModel(vehicle))

    local length         = maxDim.y - minDim.y
    local height         = maxDim.z - minDim.z
    local width          = maxDim.x - minDim.x

    local p              = Config.PreviewZone.coords

    local camDistance    = math.max(length, width) * 1.2
    local camHeight      = height * 0.8

    SetCamCoord(previewCamera,
        p.x + camDistance,
        p.y + camDistance,
        p.z + camHeight
    )

    PointCamAtEntity(previewCamera, vehicle, 0.0, 0.0, height * 0.4, true)
    SetCamFov(previewCamera, 55.0)
end

function CreatePreviewCamera(vehicle)
    local p = Config.PreviewZone.coords

    previewCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(previewCamera, true)
    RenderScriptCams(true, true, 500, true, true)

    PositionPreviewCamera(vehicle)
end

function DestroyPreviewCamera()
    if previewCamera then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(previewCamera, false)
        previewCamera = nil
    end
end

function CreatePreviewVehicle(vehicleModel)
    DestroyPreviewVehicle(previewVehicle)

    local modelHash = GetHashKey(vehicleModel)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(10) end

    local p = Config.PreviewZone.coords
    previewVehicle = CreateVehicle(modelHash, p.x, p.y, p.z - 1.0, p.w, false, false)

    SetEntityCollision(previewVehicle, false, false)
    FreezeEntityPosition(previewVehicle, true)
    SetVehicleDirtLevel(previewVehicle, 0.0)

    local liveries = GetVehicleLiveries(previewVehicle)
    local extras   = GetVehicleExtras(previewVehicle)
    local stats    = GetVehicleStats(modelHash)
    local seats    = GetVehicleModelNumberOfSeats(modelHash)

    SendNUIMessage({
        action = "vehicleGameData",
        model = vehicleModel,
        liveries = liveries,
        extras = extras,
        stats = stats,
        seats = seats
    })

    SetModelAsNoLongerNeeded(modelHash)
    return previewVehicle
end

function ApplyVehicleCustomization(vehicle, config)
    if not DoesEntityExist(vehicle) then return end

    if config.primaryColor and config.secondaryColor then
        SetVehicleColours(vehicle, config.primaryColor, config.secondaryColor)
    end

    if config.livery then
        SetVehicleModKit(vehicle, 0)

        if config.livery.type == "livery" then
            SetVehicleLivery(vehicle, config.livery.index)
        elseif config.livery.type == "mod" then
            SetVehicleMod(vehicle, 48, config.livery.index, false)
        end
    end

    if config.extras then
        for i = 0, 12 do
            if config.extras[tostring(i)] ~= nil then
                SetVehicleExtra(vehicle, i, not config.extras[tostring(i)])
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if previewVehicle and DoesEntityExist(previewVehicle) and nuiOpen then
            local currentHeading = GetEntityHeading(previewVehicle)
            SetEntityHeading(previewVehicle, currentHeading + Config.RotationSpeed)
        else
            Citizen.Wait(500)
        end
    end
end)

RegisterNUICallback('close', function(data, cb)
    CloseGarage()
    cb('ok')
end)

RegisterNUICallback('previewVehicle', function(data, cb)
    local vehicle = CreatePreviewVehicle(data.model)

    if not previewCamera then
        CreatePreviewCamera(vehicle)
    else
        PositionPreviewCamera(vehicle)
    end

    if data.config then
        Citizen.Wait(100)
        ApplyVehicleCustomization(vehicle, data.config)
    end

    cb('ok')
end)

RegisterNUICallback('spawnVehicle', function(data, cb)
    DestroyPreviewVehicle(previewVehicle)

    local modelHash = GetHashKey(data.model)

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(10)
    end

    local spawnCoords = currentGarage.spawnPoint
    local vehicle = CreateVehicle(modelHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, true, false)

    local playerJob = GetPlayerJob() or 'police' -- fallback
    local platePrefix = Config.PlaterPerJob[playerJob.name] or 'LSPD'

    local plateNumber = platePrefix .. math.random(1000, 9999)
    SetVehicleNumberPlateText(vehicle, plateNumber)

    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehRadioStation(vehicle, "OFF")
    GiveCarKey(plateNumber)

    if data.config then
        ApplyVehicleCustomization(vehicle, data.config)
    end

    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

    SetModelAsNoLongerNeeded(modelHash)

    CloseGarage()

    ShowNotification("Vehículo desplegado correctamente", "success", 3000)

    cb('ok')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DestroyPreviewVehicle(previewVehicle)
        DestroyPreviewCamera()
        if nuiOpen then
            CloseGarage()
        end
    end
end)
