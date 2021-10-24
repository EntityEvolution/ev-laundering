local random = math.random

Config = Config or {}

Config.Debug = true

Config.LaundryZones = {
    {coords = CircleZone:Create(vector3(225.45, -826.07, 30.34), 5.0, {name="Legacy Park", useZ = true}), price = random(200, 1000)},
    {coords = CircleZone:Create(vector3(206.25, -817.94, 30.77), 5.0, {name="Ladron 2", useZ = true}), price = random(200, 1000)}
}

Config.MinHours = 7
Config.MaxHours = 19

Config.Locale = {
    OpenZone = 'Open contract in %s'
}