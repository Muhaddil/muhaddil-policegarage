local ESX = nil
local QBCore = nil
local ESXVer = Config.ESXVer
local FrameWork = nil

if Config.FrameWork == "auto" then
    if GetResourceState('es_extended') == 'started' then
        if ESXVer == 'new' then
            ESX = exports['es_extended']:getSharedObject()
            FrameWork = 'esx'
        else
            ESX = nil
            while ESX == nil do
                TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
                Citizen.Wait(0)
            end
        end
    elseif GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        FrameWork = 'qb'
    else
        print('===NO SUPPORTED FRAMEWORK FOUND===')
    end
elseif Config.FrameWork == "esx" and GetResourceState('es_extended') == 'started' then
    if ESXVer == 'new' then
        ESX = exports['es_extended']:getSharedObject()
        FrameWork = 'esx'
    else
        ESX = nil
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end
elseif Config.FrameWork == "qb" and GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    FrameWork = 'qb'
else
    print('===NO SUPPORTED FRAMEWORK FOUND===')
end

function ShowNotification(text, type2, time)
    if Config.UseOXNotifications then
        lib.notify({
            title = 'Garaje',
            description = text,
            showDuration = true,
            type = type2,
            duration = time or 3000,
        })
    else
        if FrameWork == 'qb' then
            QBCore.Functions.Notify(text, type2, time)
        elseif FrameWork == 'esx' then
            TriggerEvent('esx:showNotification', text, type2, time)
        end
    end
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 150)
end

function DestroyPreviewVehicle(previewVehicle)
    if DoesEntityExist(previewVehicle) then
        DeleteEntity(previewVehicle)
        previewVehicle = nil
    end
end

function GetVehicleLiveries(vehicle)
    local liveries = {}

    local liveryCount = GetVehicleLiveryCount(vehicle)
    if liveryCount and liveryCount > 0 then
        for i = 0, liveryCount - 1 do
            table.insert(liveries, {
                type = "livery",
                index = i
            })
        end
    end

    SetVehicleModKit(vehicle, 0)
    local modLiveryCount = GetNumVehicleMods(vehicle, 48)
    if modLiveryCount and modLiveryCount > 0 then
        for i = 0, modLiveryCount - 1 do
            table.insert(liveries, {
                type = "mod",
                index = i
            })
        end
    end

    return liveries
end

function GetVehicleExtras(vehicle)
    local extras = {}

    for extraId = 0, 20 do
        if DoesExtraExist(vehicle, extraId) then
            table.insert(extras, extraId)
        end
    end

    return extras
end

function GetVehicleStats(model)
    local speed    = GetVehicleModelEstimatedMaxSpeed(model)
    local braking  = GetVehicleModelMaxBraking(model)
    local traction = GetVehicleModelMaxTraction(model)
    local agility  = GetVehicleModelEstimatedAgility(model)
    local accel    = GetVehicleModelAcceleration(model)

    local function scale(value, max)
        return math.min(math.floor((value / max) * 100), 100)
    end

    return {
        speed        = scale(speed, 50.0),
        acceleration = scale(accel, 1.2),
        handling     = scale((traction + agility) / 2, 2.0),
        braking      = scale(braking, 1.5)
    }
end

function StoreVehicle(vehicle, garage)
    if not DoesEntityExist(vehicle) then return end

    local ped = PlayerPedId()

    TaskLeaveVehicle(ped, vehicle, 0)
    Wait(1000)

    DeleteEntity(vehicle)

    ShowNotification("Vehículo guardado en el garaje", "success", 3000)
end

function GetPlayerJob()
    return lib.callback.await('muhaddil-policegarage:getPlayerJob', false)
end

function CanPlayerUseGarage(garage)
    if not garage.job then
        return true
    end

    local playerJob = GetPlayerJob()

    if type(garage.job) == "string" then
        return playerJob.name == garage.job
    elseif type(garage.job) == "table" then
        for _, job in pairs(garage.job) do
            if playerJob.name == job then
                return true
            end
        end
    end

    return false
end

function GiveCarKey(plate)
    TriggerServerEvent("vehicles_keys:selfGiveVehicleKeys", plate)
end
