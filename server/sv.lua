local state <const> = GetResourceState('es_extended') == 'started' and 'esx' or GetResourceState('qb-core') == 'started' and 'qbcore' or 'none'

GlobalState.ActiveLaundering = false

local Framework

---Returns if player has money to change
---@param playerId number
---@param resultMoney number
---@return boolean
local function DoesPlayerHaveMoney(playerId, resultMoney)
    if state == 'none' then
        -- If you want to implement into your framework you can do it here
        return true
    elseif state == 'esx' then
        if not Framework then
            TriggerEvent('esx:getSharedObject', function(obj) Framework = obj end)
        end
        if Framework then
            local xPlayer = Framework.GetPlayerFromId(playerId)
            if xPlayer then
                local blackMoney = xPlayer.getAccount('black_money').money
                if blackMoney > 0 and blackMoney > resultMoney then
                    if resultMoney < 5000000 then
                        if (blackMoney - resultMoney) > 0 then
                            return true
                        else
                            return false
                        end
                    else
                        --DropPlayer(playerId, 'sus')
                        return false, print(Config.Locale.AlertDanger:format(tostring(playerId), GetCurrentResourceName()))
                    end
                else
                    xPlayer.showNotification(Config.Locale.NoMoney)
                end
            end
        end
    elseif state == 'qbcore' then
        if not Framework then 
            Framework = exports['qb-core']:GetCoreObject()
        end
        if Framework then
            local xPlayer = Framework.Functions.GetPlayer(playerId)
            if xPlayer then
                local blackMoney = xPlayer.Functions.GetItemByName('markedbills')
                if blackMoney and blackMoney.amount > 0 and not (blackMoney.amount < resultMoney) then
                    if blackMoney.info.worth < 5000000 then
                        if (blackMoney.info.worth - resultMoney) > 0 then
                            return true
                        else
                            return false
                        end
                    end
                else
                    TriggerClientEvent('QBCore:Notify', playerId, Config.Locale.NoMoney, 'error')
                end
            end
        end
    end
    return false
end

---Creates a notification for all police
---@param message string
---@param playerCoords table
local function notifyPolice(message, playerCoords)
    local players = GetPlayers()
    for i=1, #players do
        if state == 'none' then
            return print('Yeah no framework lmao')
        end
        local coords = GetEntityCoords(GetPlayerPed(tonumber(players[i])))
        if state == 'esx' then
            local xPlayer = Framework.GetPlayerFromId(tonumber(players[i]))
            if xPlayer.getJob().name == Config.PoliceJob then
                print('test')
                xPlayer.showNotification(message:format(#(vec3(coords.x, coords.y, coords.z) - vec3(playerCoords.x, playerCoords.y, playerCoords.z))))
            end
        elseif state == 'qbcore' then
            local xPlayer = Framework.Functions.GetPlayer(players[i])
            if xPlayer.PlayerData.job.name == Config.PoliceJob and xPlayer.PlayerData.job.onduty then
                TriggerClientEvent('QBCore:Notify', players[i], message:format(#(vec3(coords.x, coords.y, coords.z) - vec3(playerCoords.x, playerCoords.y, playerCoords.z))), 'success')
            end
        end
    end
end

RegisterNetEvent('ev:launderData', function(data)
    local playerId <const> = source
    if type(data) ~="table" then
        --DropPlayer(playerId, 'Sus')
        return false, print(Config.Locale.AlertDanger:format(tostring(playerId), GetCurrentResourceName()))
    end
    if data then
        GlobalState.ActiveLaundering = false
        if data.cantiInput then
            local input = data.cantiInput
            if not type(input) == "string" then
                --DropPlayer(playerId, 'sus')
                return false, print(Config.Locale.AlertDanger:format(tostring(playerId), GetCurrentResourceName()))
            end
            if math.ceil((tonumber(input) / 100) * data.porcentaje) == data.cantiPorcentaje then
                if tonumber(input) < 0 then
                    --DropPlayer(playerId, 'sus')
                    return false, print(Config.Locale.AlertDanger:format(tostring(playerId), GetCurrentResourceName()))
                end 
                if DoesPlayerHaveMoney(playerId, tonumber(input)) then
                    local quantity = (tonumber(input) - data.cantiPorcentaje)
                    if state == 'none' then
                        print(Config.Locale.AlertSuccess:format(quantity, input))
                    elseif state == 'esx' then
                        local xPlayer = Framework.GetPlayerFromId(playerId)
                        xPlayer.removeAccountMoney('black_money', quantity)
                        xPlayer.showNotification(Config.Locale.AlertSuccess:format(quantity, input))
                    elseif state == 'qbcore' then
                        local xPlayer = Framework.Functions.GetPlayer(playerId)
                        local blackMoney = xPlayer.Functions.GetItemByName('markedbills')
                        quantity = tonumber(input)
                        local worth = math.ceil(blackMoney.info.worth - (data.porcentaje / 100) * blackMoney.info.worth)  --(blackMoney.info.worth * 100) / math.ceil(data.porcentaje / 100) bombay fix
                        xPlayer.Functions.RemoveItem('markedbills', quantity)
                        xPlayer.Functions.AddMoney('cash', worth * quantity)
                        TriggerClientEvent('QBCore:Notify', playerId, Config.Locale.AlertSuccess:format(worth * quantity, blackMoney.info.worth * quantity), 'success')
                    end
                    local luck = false
                    GlobalState.ActiveLaundering = true
                    if math.random(Config.Min, Config.Max) > Config.Prob and Config.Attack then
                        luck = true
                        if Config.NotifyPolice then
                            notifyPolice(Config.Locale.AlertPolice, GetEntityCoords(GetPlayerPed(playerId)))
                        end
                    end
                    Wait(1000)
                    TriggerClientEvent('ev:updateData', -1, luck)
                    return
                end
            else
                --DropPlayer(playerId, 'sus')
                return false, print(Config.Locale.AlertDanger:format(tostring(playerId), GetCurrentResourceName()))
            end
        end
    end
end)
