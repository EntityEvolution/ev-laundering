local random = math.random

Config = Config or {}

Config.Debug = true

Config.LaundryZones = {
    {coords = CircleZone:Create(vector3(225.45, -826.07, 30.34), 3.0, {name="~r~Legacy Park", useZ = true, data = {percentage = random(5, 15)}})},
    {coords = CircleZone:Create(vector3(206.25, -817.94, 30.77), 3.0, {name="~r~Legacy Zone", useZ = true, data = {percentage = random(5, 15)}})}
}

Config.MinHours = 7
Config.MaxHours = 19

Config.ContractKey = 38

Config.Locale = {
    OpenZone = 'Open contract in %s',
    NoData = 'No input was added!',
    NegativeValue = 'You cannot clean a negative value!'
}