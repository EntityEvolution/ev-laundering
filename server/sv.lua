local state <const> = GetResourceState('es_extended') == 'started' and 'esx' or GetResourceState('vrp') == 'started' and 'vrp' or GetResourceState('qb-core') == 'started' and 'qbcore' or 'none'

GlobalState.ActiveLaundering = false

local Framework

---Returns if player has money
---@param playerId number
---@return boolean
local function DoesPlayerHaveMoney(playerId)
    if state == 'none' then
        -- If you want to implement into your framework you can do it here
        return true, print('Hey, you have money!')
    elseif state == 'esx' then
        
    elseif state == 'qbcore' then

    elseif state == 'vrp' then

    end
end

RegisterNetEvent('ev:launderData', function(data)
    local playerId <const> = source
    if type(data) ~="table" then
        DropPlayer(playerId, 'Sus')
        return false
    end

    if DoesPlayerHaveMoney(playerId) then
        
    end
end)