local mod_gui = require("mod-gui")
local name = "game-speed-button"
local speeds

local function load_speed_settings()
    local speed_settings_under_1 = string.gmatch(settings.global["gsb-speed-settings-under-1"].value, '([0-9.]+)')
    local speed_settings_over_1 = string.gmatch(settings.global["gsb-speed-settings-over-1"].value, '([0-9.]+)')

    speeds = {}

    for speed in speed_settings_under_1 do
        local value = tonumber(speed)
        if value >= 0.01 and value < 1 then
            speeds[#speeds + 1] = value
        end
    end

    speeds[#speeds + 1] = 1

    for speed in speed_settings_over_1 do
        local value = tonumber(speed)
        if value > 1 and value <= 60 then
            speeds[#speeds + 1] = value
        end
    end

    if #speeds > 1 then
       table.sort(speeds, function(a, b) return a < b end)
    end
end

local function update_button()
    local caption = ""
    if game.speed >= 1 then
        caption = "x " .. tostring(math.floor(game.speed * 100) / 100)
    else
        caption = "/ " .. tostring(math.floor(100 / game.speed) / 100)
    end

    for _, player in pairs(game.players) do
        local button_flow = mod_gui.get_button_flow(player)
        if not button_flow[name] then
            button_flow.add {
                type = "button",
                name = name,
                caption = caption,
                tooltip = {"game-speed-button.tt"},
                style = mod_gui.button_style
            }
        else
            button_flow[name].caption = caption
        end
    end
end

local function button_clicked(event)
    if event.element.name == name then
        if event.button == defines.mouse_button_type.left then
            if game.speed < 1 then
                game.speed = 1
            else
                for index = 1, #speeds, 1 do
                    if speeds[index] > game.speed then
                        game.speed = speeds[index]
                        break
                    end
                end
            end
        elseif event.button == defines.mouse_button_type.right then
            if game.speed > 1 then
                    game.speed = 1
            else
                for index = #speeds, 1, -1 do
                    if speeds[index] < game.speed then
                        game.speed = speeds[index]
                        break
                    end
                end
            end
        end
        update_button()
    end
end

load_speed_settings()
script.on_configuration_changed(update_button)
script.on_event(defines.events.on_runtime_mod_setting_changed, load_speed_settings)
script.on_event(defines.events.on_player_created, update_button)
script.on_event(defines.events.on_gui_click, button_clicked)
