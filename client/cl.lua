local isLaundryOpen = false
local laundryZone

RegisterNUICallback('getMoneyData', function(data, cb)
    if isLaundryOpen then
        print(data)
    end
    cb({})
end)

---Returns if player between two hours
---@return boolean
local function isInTime()
    if Config.Debug then return true end
    local hours = GetClockHours()
    if hours > Config.MinHours and hours < Config.MaxHours and not GlobalState.ActiveLaundering then
        return true
    end
    return false
end

---Loads a notification
---@param ped number
---@param message string
local function showNotification(ped, message)
    ---Show floating notification at coords
    ---@param coords any
    local function showFloatingNotification(coords)
        AddTextEntry('laundryFloat', message)
        SetFloatingHelpTextWorldPosition(1, coords)
        SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
        BeginTextCommandDisplayHelp('laundryFloat')
        EndTextCommandDisplayHelp(2, false, false, -1)
    end
    CreateThread(function()
        while true do
            local coords = GetEntityCoords()
            showFloatingNotification(vec3(coords.x, coords.y, coords.z))
            if IsControlJustReleased(0, 0) then
                isLaundryOpen = true
                break
            end
            Wait(5)
        end
    end)
end

for _, v in pairs(Config.LaundryZones) do
    laundryZone = ComboZone:Create({v.coords}, {
        name = v.coords.name,
        debugPoly = Config.Debug
    })

    laundryZone:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            if isInTime() then
                showNotification(PlayerPedId(), Config.Locale.OpenZone:format(zone.name))
            else

            end
        end
    end)
end