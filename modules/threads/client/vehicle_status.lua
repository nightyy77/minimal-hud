local interface = require("modules.interface.client")
local utility = require("modules.utility.shared.main")
local logger = require("modules.utility.shared.logger")
local functions = require("config.functions")
local config = require("config.shared")

local VehicleStatusThread = {}
VehicleStatusThread.__index = VehicleStatusThread

function VehicleStatusThread.new(playerStatus, seatbeltLogic)
    local self = setmetatable({}, VehicleStatusThread)
    self.playerStatus = playerStatus
    self.seatbelt = seatbeltLogic

    SetHudComponentPosition(6, 999999.0, 999999.0) -- VEHICLE NAME
    SetHudComponentPosition(7, 999999.0, 999999.0) -- AREA NAME
    SetHudComponentPosition(8, 999999.0, 999999.0) -- VEHICLE CLASS
    SetHudComponentPosition(9, 999999.0, 999999.0) -- STREET  NAME

    return self
end

function GetNosLevel(veh)
    local noslevelraw = functions.getNosLevel(veh)
    local noslevel

    if noslevelraw == nil then
        noslevel = 0
    else
        noslevel = math.floor(noslevelraw)
    end

    return noslevel
end

function VehicleStatusThread:start()
    CreateThread(function()
        local ped = PlayerPedId()
        local playerStatusThread = self.playerStatus
        local convertRpmToPercentage = utility.convertRpmToPercentage
        local convertEngineHealthToPercentage = utility.convertEngineHealthToPercentage

        playerStatusThread:setIsVehicleThreadRunning(true)

        while IsPedInAnyVehicle(ped, false) do
            local vehicle = GetVehiclePedIsIn(ped, false)
            local vehicleType = GetVehicleTypeRaw(vehicle)
            local engineHealth = convertEngineHealthToPercentage(GetVehicleEngineHealth(vehicle))
            local noslevel = GetNosLevel(vehicle)
            local fuelValue = math.max(0, math.min(functions.getVehicleFuel(vehicle), 100))
            local engineState = GetIsVehicleEngineRunning(vehicle)
            local fuel = math.floor(fuelValue)
            local currentGears = GetVehicleHighGear(vehicle)
			local newGears = currentGears

            if currentGears == 1 then
				newGears = 0
			end

            local speed
            local normalizedSpeedUnit = string.lower(config.speedUnit)

            if normalizedSpeedUnit == "kph" then
                speed = math.floor(GetEntitySpeed(vehicle) * 3.6) -- Convert m/s to KPH
            elseif normalizedSpeedUnit == "mph" then
                speed = math.floor(GetEntitySpeed(vehicle) * 2.236936) -- Convert m/s to MPH
            else
                logger.error("Invalid speed unit in config. Expected 'kph' or 'mph', but got:", config.speedUnit)
            end

            local rpm
            if vehicleType == 8 then -- Helicopters: Simulate RPM based on speed
                rpm = math.min(speed / 150, 1) * 100
            else -- All other vehicles: Use actual RPM
                rpm = convertRpmToPercentage(GetVehicleCurrentRpm(vehicle))
            end

            interface:message("state::vehicle::set", {
                speedUnit = config.speedUnit,
                speed = speed,
                rpm = rpm,
                engineHealth = engineHealth,
                engineState = engineState,
                gears = newGears,
                fuel = fuel,
                nos = noslevel,
            })

            Wait(100)
        end

        if self.seatbelt then
            logger.verbose("(vehicleStatusThread) seatbelt found, toggling to false")
            self.seatbelt:toggle(false)
        end

        playerStatusThread:setIsVehicleThreadRunning(false)
        logger.verbose("(vehicleStatusThread) Vehicle status thread ended.")
    end)
end

return VehicleStatusThread
