local exec = require("hyprlandrc.common.utils").exec

hl.on("hyprland.start", function()
	hl.dsp.exec_cmd "uwsm finalize"
	exec "fcitx5 -d"
end)
