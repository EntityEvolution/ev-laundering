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
                        return false, print(tostring(playerId) .. ' tried doing some sus stuff in ' .. GetCurrentResourceName())
                    end
                else
                    xPlayer.showNotification('You do not have enough money!')
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
                    TriggerClientEvent('QBCore:Notify', playerId, 'You do not have enough money or you are putting more than you have!', 'error')
                end
            end
        end
    end
    return false
end

RegisterNetEvent('ev:launderData', function(data)
    local playerId <const> = source
    if type(data) ~="table" then
        --DropPlayer(playerId, 'Sus')
        return false, print(tostring(playerId) .. ' tried doing some sus stuff in ' .. GetCurrentResourceName())
    end

    if data then
        local input = data.cantiInput
        if not type(input) == "string" then
            --DropPlayer(playerId, 'sus')
            return false, print(tostring(playerId) .. ' tried doing some sus stuff in ' .. GetCurrentResourceName())
        end
        if math.ceil((tonumber(input) / 100) * data.porcentaje) == data.cantiPorcentaje then
            if tonumber(input) < 0 then
                --DropPlayer(playerId, 'sus')
                return false, print(tostring(playerId) .. ' tried doing some sus stuff in ' .. GetCurrentResourceName())
            end 
            if DoesPlayerHaveMoney(playerId, tonumber(input)) then
                local quantity = (tonumber(input) - data.cantiPorcentaje)
                if state == 'none' then
                    print('You have +$' .. tostring(quantity) .. ' now!')
                elseif state == 'esx' then
                    local xPlayer = Framework.GetPlayerFromId(playerId)
                    xPlayer.removeAccountMoney('black_money', quantity)
                    xPlayer.showNotification('You have +$' .. tostring(quantity) .. ' now!')
                elseif state == 'qbcore' then
                    local xPlayer = Framework.Functions.GetPlayer(playerId)
                    local blackMoney = xPlayer.Functions.GetItemByName('markedbills')
                    local quantity = tonumber(input)
                    local worth = math.ceil(blackMoney.info.worth - (data.porcentaje / 100) * blackMoney.info.worth)  --(blackMoney.info.worth * 100) / math.ceil(data.porcentaje / 100) bombay fix
                    xPlayer.Functions.RemoveItem('markedbills', quantity)
                    xPlayer.Functions.AddMoney('cash', worth * quantity)
                    TriggerClientEvent('QBCore:Notify', playerId ,'Congrats, you just washed $' .. worth * quantity , 'success')
                end
            end
        else
            --DropPlayer(playerId, 'sus')
            return false, print(tostring(playerId) .. ' tried doing some sus stuff in ' .. GetCurrentResourceName())
        end
    end
end)
