local mod_gui = require("mod-gui")
local name = 'game-speed-button'
local speed_settings = string.gmatch(settings.startup["gsb-speed-settings"].value, '([0-9.]+)')

local speeds = {}
for speed in speed_settings do
    local value = tonumber(speed)
    if value then
        speeds[#speeds + 1] = value
    end
end

local function update_button()
    local caption
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
                tooltip = { "game-speed-button.tt" },
                style = mod_gui.button_style
            }
        else
            button_flow[name].caption = caption
        end
    end
end

local function on_gui_click(event)
    if event.element.name == name then
        if event.button == defines.mouse_button_type.left then
            if game.speed < 1 then
                game.speed = 1
            else
                for i = 1, #speeds, 1 do
                    if speeds[i] > game.speed then
                        game.speed = speeds[i]
                        break
                    end
                end
            end

        elseif event.button == defines.mouse_button_type.middle then
            game.speed = 1

        elseif event.button == defines.mouse_button_type.right then
            if game.speed > 1 then
                    game.speed = 1
            else
                for i = #speeds, 1, -1 do
                    if speeds[i] < game.speed then
                            game.speed = speeds[i]
                        break
                    end
                end
            end
        end
        update_button()
    end
end

script.on_configuration_changed(update_button)
script.on_event(defines.events.on_player_created, update_button)
script.on_event(defines.events.on_gui_click, on_gui_click)
