local customFramework = {}
customFramework.__index = customFramework

function customFramework.new()
    local self = setmetatable({}, customFramework)
    return self
end

-- Change this function to return the hunger value of the player.
function customFramework:getPlayerHunger()
    return 100
end

-- Change this function to return the thirst value of the player.
function customFramework:getPlayerThirst()
    return 100
end

-- Change this function to return the stress value of the player.
function customFramework:getPlayerStress()
    return 0
end

function customFramework:getPlayerOxygen()
    return 100
end

function customFramework:getPlayerStamina()
    return 100
end

return customFramework
