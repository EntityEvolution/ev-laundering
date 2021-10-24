local state <const> = GetResourceState('es_extended') == 'started' and 'esx' or GetResourceState('vrp') == 'started' and 'vrp' or GetResourceState('qb-core') == 'started' and 'qbcore' or 'none'

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
                if blackMoney > 0 then
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
                end
            end
        end
    elseif state == 'qbcore' then
        
    elseif state == 'vrp' then

    end
    return false
end

RegisterNetEvent('ev:launderData', function(data)
    local playerId <const> = source
    print(data)
    if type(data) ~="table" then
        --DropPlayer(playerId, 'Sus')
        return false, print(tostring(playerId) .. ' tried doing some sus stuff in ' .. GetCurrentResourceName())
    end

    if data then
        local input = data.cantiInput
        if not type(data.cantiInput) == "string" then
            --DropPlayer(playerId, 'sus')
            return false, print(tostring(playerId) .. ' tried doing some sus stuff in ' .. GetCurrentResourceName())
        end
        if math.floor((tonumber(input) / 100) * data.porcentaje) == data.cantiPorcentaje then
            if DoesPlayerHaveMoney(playerId, tonumber(input)) then
                if state == 'none' then
                    print('Hey, you have money!')
                elseif state == 'esx' then

                elseif state == 'qbcore' then
        
                elseif state == 'vrp' then
            
                end
            end
        else
            --DropPlayer(playerId, 'sus')
            return false, print(tostring(playerId) .. ' tried doing some sus stuff in ' .. GetCurrentResourceName())
        end
    end
end)