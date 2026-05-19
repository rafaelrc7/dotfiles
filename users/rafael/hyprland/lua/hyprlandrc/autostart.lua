local exec = require("hyprlandrc.common.utils").exec

hl.on("hyprland.start", function() exec "fcitx5 -d" end)
