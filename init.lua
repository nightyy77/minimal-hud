if not IsDuplicityVersion() then
    local config = require("config.shared")
    local playerStatusClass = require("modules.threads.client.player_status")
    local vehicleStatusClass = require("modules.threads.client.vehicle_status")
    local seatbeltLogicClass = require("modules.seatbelt.client")
    local utility = require("modules.utility.shared.main")
    local logger = require("modules.utility.shared.logger")
    local interface = require("modules.interface.client")

    local seatbeltLogic = seatbeltLogicClass.new()
    local playerStatusThread = playerStatusClass.new()
    local vehicleStatusThread = vehicleStatusClass.new(playerStatusThread, seatbeltLogic)
    local framework = utility.isFrameworkValid() and require("modules.frameworks." .. config.framework:lower()).new() or false

    playerStatusThread:start(vehicleStatusThread, seatbeltLogic, framework)

    exports("toggleHud", function(state)
        interface:toggle(state or nil)
        DisplayRadar(state)
        logger.info("(exports:toggleHud) Toggled HUD to state: ", state)
    end)

    RegisterCommand("togglehud", function()
        interface:toggle()
    end, false)

    interface:on("APP_LOADED", function(_, cb)
        local data = {
            config = config,
            minimap = utility.calculateMinimapSizeAndPosition(),
        }

        cb(data)

        CreateThread(utility.setupMinimap)
    end)

    return
end

local sv_utils = require("modules.utility.server.main")

CreateThread(function()
    if not sv_utils.isInterfaceCompiled() then
        print("^1Interface not compiled, either compile the interface or download a compiled version here: ^0https://github.com/vipexv/minimal-hud/releases/latest")
    end

    sv_utils.versionCheck("vipexv/minimal-hud")
end)
