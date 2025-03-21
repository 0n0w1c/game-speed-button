data.raw["gui-style"].default["bold_textbox"] = {
    type = "textbox_style",
    font = "default-bold",
    minimal_width = 50,
    maximal_width = 100
}

data.extend({
    {
        type = "custom-input",
        name = "gsb-increase",
        key_sequence = "CONTROL + EQUALS",
    },
    {
        type = "custom-input",
        name = "gsb-decrease",
        key_sequence = "CONTROL + MINUS",
    },
    {
        type = "shortcut",
        name = "gsb-toggle-button",
        action = "lua",
        icon = "__game-speed-button__/graphics/icons/x1.png",
        icon_size = 64,
        small_icon = "__game-speed-button__/graphics/icons/x1-24.png",
        small_icon_size = 24,
        associated_control_input = "give-gsb-toggle-button",
        style = "default",
        toggleable = true,
        order = "gsb"
    }
})
