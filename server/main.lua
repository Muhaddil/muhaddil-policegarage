local playerData = {}

RegisterNetEvent('policegarage:logVehicleSpawn')
AddEventHandler('policegarage:logVehicleSpawn', function(vehicleModel)
    local src = source
    local playerName = GetPlayerName(src)
    local identifier = GetPlayerIdentifier(src, 0)
    
    -- print(string.format('[Police Garage] %s (ID: %s) spawneó: %s', playerName, identifier, vehicleModel))
    
    -- MySQL.Async.execute('INSERT INTO police_garage_logs (identifier, player_name, vehicle_model, spawn_time) VALUES (@identifier, @name, @model, NOW())', {
    --     ['@identifier'] = identifier,
    --     ['@name'] = playerName,
    --     ['@model'] = vehicleModel
    -- })
end)

RegisterCommand('garagestats', function(source, args, rawCommand)
    local src = source
    
    if not IsPlayerAdmin(src) then return end
    
    local totalPlayers = 0
    local totalFavorites = 0
    local totalConfigs = 0
    
    for k, v in pairs(playerData) do
        totalPlayers = totalPlayers + 1
        if v.favorites then
            totalFavorites = totalFavorites + #v.favorites
        end
        if v.vehicleConfigs then
            for _, _ in pairs(v.vehicleConfigs) do
                totalConfigs = totalConfigs + 1
            end
        end
    end
    
    TriggerClientEvent('chat:addMessage', src, {
        color = {0, 212, 255},
        multiline = true,
        args = {"Police Garage", string.format("Jugadores: %d | Favoritos totales: %d | Configs guardadas: %d", 
            totalPlayers, totalFavorites, totalConfigs)}
    })
end, false)

print('^2[Police Garage]^7 Sistema de garaje policial iniciado correctamente')
