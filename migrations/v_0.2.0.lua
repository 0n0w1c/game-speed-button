local constants = require("constants")

storage = storage or {}

if settings.global["gsb-speed-settings-under-1"] then
    storage.gsb_under_1 = settings.global["gsb-speed-settings-under-1"].value
else
    storage.gsb_under_1 = constants.default_under_1
end

if settings.global["gsb-speed-settings-over-1"] then
    storage.gsb_over_1 = settings.global["gsb-speed-settings-over-1"].value
else
    storage.gsb_over_1 = constants.default_over_1
end
