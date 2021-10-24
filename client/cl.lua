local isLaundryOpen = false
local laundryZone

RegisterNUICallback('getMoneyData', function(data, cb)
    if isLaundryOpen then
        print(data)
    end
    SetNuiFocus(false, false)
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

---Show floating notification at coords
---@param message string
---@param coords table
local function showFloatingNotification(message, coords)
    AddTextEntry('laundryFloat', message)
    SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('laundryFloat')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

---Loads a notification
---@param ped number
---@param message string
local function showNotification(ped, message)
    CreateThread(function()
        while true do
            local coords = GetEntityCoords(ped)
            showFloatingNotification(message, coords)
            if IsControlJustReleased(0, Config.ContractKey) then
                isLaundryOpen = true
                SendNUIMessage({action = 'openMenu'})
                SetNuiFocus(true, true)
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
            end
        end
    end)
end