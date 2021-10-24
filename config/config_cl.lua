local random = math.random

Config = Config or {}

Config.Debug = true

Config.Peds = {
    'cs_fbisuit_01',
    'cs_martinmadrazo',
    'cs_movpremmale',
    'cs_paper',
    'cs_solomon',
    'cs_orleans'
}
Config.Anim = false -- If not true then it will default to whatever it's on scene

Config.LaundryZones = {
    {coords = CircleZone:Create(vector3(225.45, -826.07, 30.34), 3.0, {name="~r~Legacy Park", useZ = true, data = {percentage = random(5, 15), pedModel = Config.Peds[random(1, #Config.Peds)], dict = 'anim@heists@prison_heiststation@cop_reactions', anim = 'cop_b_idle', scene = 'WORLD_HUMAN_CLIPBOARD'}})},
    {coords = CircleZone:Create(vector3(206.25, -817.94, 30.77), 3.0, {name="~r~Legacy Zone", useZ = true, data = {percentage = random(5, 15), pedModel = Config.Peds[random(1, #Config.Peds)], dict = 'anim@heists@prison_heiststation@cop_reactions', anim = 'cop_b_idle', scene = 'WORLD_HUMAN_CLIPBOARD'}})}
}

Config.MinHours = 7 -- Game time
Config.MaxHours = 19 -- Game time
Config.DefaultTime = 5000 -- In milliseconds

Config.ContractKey = 38 -- Currently E

Config.Locale = {
    OpenZone = 'Open contract in %s',
    NoData = 'No input was added!',
    NegativeValue = 'You cannot clean a negative value!',
    SomeoneCleaned = 'Someone already washed their money!'
}