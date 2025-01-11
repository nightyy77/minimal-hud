local oxFramework = {}
oxFramework.__index = oxFramework

function oxFramework.new()
    local self = setmetatable({}, oxFramework)
    self.values = {}

    AddEventHandler("ox:statusTick", function(data)
        self.values.hunger = 100 - data.hunger
        self.values.thirst = 100 - data.thirst
        self.values.stress = data.stress
        self.values.stamina = 100 - data.stamina
        self.values.oxygen = 100 - data.oxygen
    end)

    return self
end

function oxFramework:getPlayerHunger()
    return self.values.hunger
end

function oxFramework:getPlayerThirst()
    return self.values.thirst
end

function oxFramework:getPlayerStress()
    return self.values.stress
end



function oxFramework:getPlayerOxygen()
    return self.values.oxygen
end

function oxFramework:getPlayerStamina()
    return self.values.stamina
end

return oxFramework
