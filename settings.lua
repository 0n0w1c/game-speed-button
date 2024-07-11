data:extend({
    {
        type = "string-setting",
        name = "gsb-speed-settings-under-1",
        setting_type = "startup",
        default_value = ".1 .5",
        allow_blank = true,
        auto_trim = true,
        order = "1"
    },
    {
        type = "string-setting",
        name = "gsb-speed-settings-over-1",
        setting_type = "startup",
        default_value = "2 5 10 60",
        allow_blank = true,
        auto_trim = true,
        order = "2"
    }
})
