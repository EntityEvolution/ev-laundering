local createdPeds = createdPeds or {}
local currentPed = nil
local isLaundryOpen = false
local laundryZone, insideZone

local insert = table.insert

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


---Returns/inserts a created ped
---@param model string
---@param coords table
---@param dict string
---@param anim string
---@param scene string
---@param agressive boolean
---@return number
local function createPed(model, coords, dict, anim, scene, agressive)
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 1500 do
        timeout = timeout + 1
        Wait(1)
    end

    local cPed = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, false)
    if not agressive then
        FreezeEntityPosition(cPed, true)
        SetEntityInvincible(cPed, true)
        SetBlockingOfNonTemporaryEvents(cPed, true)
        SetPedFleeAttributes(cPed, 0, false)
        SetPedCombatAttributes(cPed, 17, true)
    else
        SetPedRelationshipGroupHash(cPed, GetHashKey('launderDefense'))
        SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), GetHashKey('launderDefense'))
        SetRelationshipBetweenGroups(5, GetHashKey('launderDefense'), GetHashKey('PLAYER'))
        SetPedCombatAttributes(cPed, 46, true)
    end

    if Config.Anim and dict then
        local timeout2 = 0
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) and timeout2 < 1500 do
            timeout2 = timeout2 + 1
            Wait(1)
        end
        TaskPlayAnim(cPed, dict, anim, 0.5, 1.0, -1, 1, 0, false, false, false)
    end

    if not Config.Anim and scene then
        TaskStartScenarioInPlace(cPed, scene, 0, true)
    end

    insert(createdPeds, cPed)
    return cPed
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
                if not GlobalState.ActiveLaundering then
                    if isInTime() and not isLaundryOpen then
                        showNotification(PlayerPedId(), Config.Locale.OpenZone:format(zone.name), zone.data.percentage)
                        if Config.UsePeds then
                            currentPed = createPed(zone.data.pedModel, zone.center, zone.data.dict, zone.data.anim, zone.data.scene)
                        end
                    else
                        showNoti(Config.Locale.WrongHour)
                    end
                else
                    showNoti(Config.Locale.SomeoneCleaned)
                end
            end
        else
            if insideZone then
                insideZone = false
                showNotification()
                if Config.UsePeds then
                    if DoesEntityExist(currentPed) then
                        DeleteEntity(currentPed)
                        currentPed = nil
                    end
                end
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

AddEventHandler('onClientResourceStop', function(name)
    if GetCurrentResourceName() == name then
        if Config.UsePeds then
            for _, v in pairs(createdPeds) do
                if DoesEntityExist(v) then
                    DeletePed(v)
                end
            end
        end
    end
end)

RegisterNetEvent('ev:updateData', function(luck)
    if luck then
        AddRelationshipGroup('launderDefense')
        local coords = GetEntityCoords(currentPed)
        local currPed
        for i = 1, Config.PedAttack, 1 do
            local spawnCoords = coords + vector3(math.random(-10, 10), math.random(-10, 10) ,0)
            currPed = createPed(`cs_fbisuit_01`, spawnCoords, _, _, _, true)
            GiveWeaponToPed(currPed, GetHashKey(Config.PedWeapon), 100, false, true)
            SetCurrentPedWeapon(currPed, GetHashKey(Config.PedWeapon), true)
            TaskShootAtEntity(currPed, ped, 5000, `FIRING_PATTERN_FULL_AUTO`)
        end
    end
    if GlobalState.ActiveLaundering then
        local duration = GetGameTimer() + Config.DefaultTime
        CreateThread(function()
            while GlobalState.ActiveLaundering do
                if GetGameTimer() > duration then
                    local data = {
                        state = 'yes, please'
                    }
                    TriggerServerEvent('ev:launderData', data)
                end
                Wait(1000)
            end
        end)
    end
end)