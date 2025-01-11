local qbFramework = {}
qbFramework.__index = qbFramework

function qbFramework.new()
    local self = setmetatable({}, qbFramework)
    self.values = {}

    RegisterNetEvent("hud:client:UpdateNeeds", function(hunger, thirst)
        self.values.hunger = hunger
        self.values.thirst = thirst
    end)

    RegisterNetEvent("hud:client:UpdateStress", function(stress)
        self.values.stress = stress
    end)

    return self
end

function qbFramework:getPlayerHunger()
    return self.values.hunger or "disabled"
end

function qbFramework:getPlayerThirst()
    return self.values.thirst or "disabled"
end

function qbFramework:getPlayerStress()
    return self.values.stress or "disabled"
end

return qbFramework
