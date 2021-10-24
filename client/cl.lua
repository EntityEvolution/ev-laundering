local isLaundryOpen = false
local laundryZone, insideZone

---Returns a GTA style notification
---@param message string
local function showNoti(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(0, 1)
end

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
---@param state boolean
---@param ped number
---@param message string
---@param percentage number
local function showNotification(ped, message, percentage)
    if not isLaundryOpen and insideZone then
        CreateThread(function()
            while insideZone do
                local coords = GetEntityCoords(ped)
                showFloatingNotification(message, coords)
                if IsControlJustReleased(0, Config.ContractKey) then
                    isLaundryOpen = true
                    SendNUIMessage({action = 'openMenu', zonePercentage = percentage})
                    SetNuiFocus(true, true)
                    break
                end
                Wait(5)
            end
        end)
    end
end

for _, v in pairs(Config.LaundryZones) do
    laundryZone = ComboZone:Create({v.coords}, {
        name = v.coords.name,
        debugPoly = Config.Debug
    })

    laundryZone:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            if not insideZone then
                insideZone = true
                if isInTime() and not isLaundryOpen then
                    showNotification(PlayerPedId(), Config.Locale.OpenZone:format(zone.name), zone.data.percentage)
                end
            end
        else
            if insideZone then
                insideZone = false
                showNotification()
            end
        end
    end)
end

RegisterNUICallback('getMoneyData', function(data, cb)
    if isLaundryOpen then
        if data then
            if not data.notify then
                TriggerServerEvent('ev:launderData', data)
                SetNuiFocus(false, false)
                isLaundryOpen = false
            else
                showNoti(Config.Locale[data.notify])
            end
        else
            SetNuiFocus(false, false)
            isLaundryOpen = false
        end
    end
    cb({})
end)