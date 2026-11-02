local exec_cmd = require("hyprlandrc.common.utils").exec_cmd

hl.on("hyprland.start", function()
	hl.exec_cmd "uwsm finalize"
	exec_cmd "fcitx5 -d"
end)
