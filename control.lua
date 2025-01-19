local mod_gui = require("mod-gui")
local constants = require("constants")

local name = "game-speed-button"
local speeds

local function load_speed_settings()
    local speed_settings_under_1 = string.gmatch(storage.gsb_under_1, "([0-9.]+)")
    local speed_settings_over_1 = string.gmatch(storage.gsb_over_1, "([0-9.]+)")

    speeds = {}

    for speed in speed_settings_under_1 do
        local value = tonumber(speed)
        if value and value >= 0.01 and value < 1 then
            speeds[#speeds + 1] = value
        end
    end

    speeds[#speeds + 1] = 1

    for speed in speed_settings_over_1 do
        local value = tonumber(speed)
        if value and value > 1 and value <= 60 then
            speeds[#speeds + 1] = value
        end
    end

    if #speeds > 1 then
        table.sort(speeds)
    end
end

local function update_button()
    local player = game.get_player(1)
    if not player then return end

    local caption = ""
    if game.speed >= 1 then
        caption = "x " .. tostring(math.floor(game.speed * 100) / 100)
    else
        caption = "/ " .. tostring(math.floor(100 / game.speed) / 100)
    end

    local button_flow = mod_gui.get_button_flow(player)

    if not button_flow[name] then
        button_flow.add {
            type = "button",
            name = name,
            caption = caption,
            tooltip = { "gui.gsb-tool-tip" },
            style = mod_gui.button_style
        }
    else
        button_flow[name].caption = caption
        button_flow[name].tooltip = { "gui.gsb-tool-tip" }
    end
end

local function create_settings_gui(player)
    if player.gui.screen.gsb_settings_frame then
        player.gui.screen.gsb_settings_frame.destroy()
    end

    local frame = player.gui.screen.add {
        type = "frame",
        name = "gsb_settings_frame",
        direction = "vertical"
    }
    frame.auto_center = true

    local titlebar_flow = frame.add {
        type = "flow",
        name = "gsb_titlebar_flow",
        direction = "horizontal"
    }

    titlebar_flow.add {
        type = "label",
        caption = { "gui.gsb-settings-title" },
        ignored_by_interaction = true,
        style = "frame_title",
    }

    local draggable_space = titlebar_flow.add {
        type = "empty-widget",
        name = "gsb_draggable_space",
        style = "draggable_space_header",
        ignored_by_interaction = false,
    }
    draggable_space.style.height = 24
    draggable_space.style.horizontally_stretchable = true
    draggable_space.drag_target = frame

    local close_button = titlebar_flow.add {
        type = "sprite-button",
        name = "gsb_close_button",
        sprite = "utility/close",
        style = "close_button",
        mouse_button_filter = { "left" }
    }

    close_button.style.height = 24
    close_button.style.width = 24

    local inner_frame = frame.add {
        type = "frame",
        name = "gsb_inner_frame",
        direction = "vertical",
        style = "inside_shallow_frame"
    }

    local under_1_flow = inner_frame.add {
        type = "flow",
        name = "gsb_under_1_flow",
        direction = "horizontal"
    }

    under_1_flow.style.top_padding = 10
    under_1_flow.style.left_padding = 10

    under_1_flow.add {
        type = "label",
        caption = { "gui.gsb-under-1" },
        style = "label"
    }

    under_1_flow.add {
        type = "textfield",
        name = "gsb_under_1_textfield",
        text = storage.gsb_under_1,
        tooltip = { "gui.gsb-under-1-tool-tip" },
        style = "bold_textbox"
    }

    local over_1_flow = inner_frame.add {
        type = "flow",
        name = "gsb_over_1_flow",
        direction = "horizontal"
    }

    over_1_flow.style.top_padding = 12
    over_1_flow.style.bottom_padding = 10
    over_1_flow.style.left_padding = 10

    over_1_flow.add {
        type = "label",
        caption = { "gui.gsb-over-1" },
        style = "label"
    }
    over_1_flow.add {
        type = "textfield",
        name = "gsb_over_1_textfield",
        text = storage.gsb_over_1,
        tooltip = { "gui.gsb-over-1-tool-tip" },
        style = "bold_textbox"
    }

    local button_flow = frame.add {
        type = "flow",
        name = "gsb_button_flow",
        direction = "horizontal"
    }

    button_flow.style.top_padding = 8
    button_flow.style.bottom_padding = 0
    button_flow.style.left_padding = 40

    button_flow.add {
        type = "button",
        name = "gsb_save_button",
        caption = { "gui.gsb-save" },
        style = "button"
    }

    player.opened = frame
    return frame
end

local function handle_gui_click(event)
    local player = game.get_player(event.player_index)
    if not player or not event.element or not event.element.valid then return end

    local element = event.element

    if element.name == "game-speed-button" then
        if event.button == defines.mouse_button_type.left then
            if event.control then
                create_settings_gui(player)
            else
                if game.speed < 1 then
                    game.speed = 1
                else
                    for index = 1, #speeds do
                        if speeds[index] > game.speed then
                            game.speed = speeds[index]
                            break
                        end
                    end
                end
                update_button()
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
            update_button()
        end
    elseif element.name == "gsb_save_button" then
        local under_1_textfield =
            player.gui.screen.gsb_settings_frame.gsb_inner_frame.gsb_under_1_flow.gsb_under_1_textfield
        local over_1_textfield =
            player.gui.screen.gsb_settings_frame.gsb_inner_frame.gsb_over_1_flow.gsb_over_1_textfield

        storage.gsb_under_1 = under_1_textfield.text
        storage.gsb_over_1 = over_1_textfield.text

        load_speed_settings()
        update_button()

        player.gui.screen.gsb_settings_frame.destroy()
        player.opened = nil
    elseif element.name == "gsb_close_button" then
        if player.gui.screen.gsb_settings_frame then
            player.gui.screen.gsb_settings_frame.destroy()
            player.opened = nil
        end
    end
end

local function handle_close_settings(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    if player.gui.screen.gsb_settings_frame then
        player.gui.screen.gsb_settings_frame.destroy()
        player.opened = nil
    end
end

local function initialize_globals()
    storage = storage or {}

    storage.gsb_under_1 = storage.gsb_under_1 or constants.default_under_1
    storage.gsb_over_1 = storage.gsb_over_1 or constants.default_over_1
end

local function register_event_handlers()
    script.on_event(defines.events.on_player_created, update_button)
    script.on_event(defines.events.on_gui_click, handle_gui_click)
    script.on_event({ "close-gsb-settings-e", "close-gsb-settings-esc" }, handle_close_settings)
end

script.on_init(function()
    initialize_globals()
    register_event_handlers()
    load_speed_settings()
end)

script.on_load(function()
    register_event_handlers()
    load_speed_settings()
end)

script.on_configuration_changed(function()
    initialize_globals()
    register_event_handlers()
    load_speed_settings()
    update_button()
end)
