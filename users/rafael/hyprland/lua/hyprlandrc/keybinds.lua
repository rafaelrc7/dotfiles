local programs = require("hyprlandrc.common.globals").programs

local dsp_exec_cmd = require("hyprlandrc.common.utils").dsp_exec_cmd
local join_strings = require("hyprlandrc.common.utils").join_strings

local function keys(keysTable) return join_strings(keysTable, " + ") end

local mod = "SUPER"

hl.config {
	binds = {
		allow_workspace_cycles = true,
		hide_special_on_workspace_change = true,
		workspace_back_and_forth = true,
		workspace_center_on = 1,
	},
	cursor = {
		inactive_timeout = 5,
		no_warps = false,
	},
}

-- Apps
hl.bind(keys { mod, "RETURN" }, dsp_exec_cmd(programs.terminal), { description = "Open terminal" })
hl.bind(keys { mod, "D" }, dsp_exec_cmd(programs.launcher_menu), { description = "Open launcher menu" })
hl.bind(keys { mod, "Q" }, dsp_exec_cmd(programs.browser), { description = "Open web browser" })
hl.bind(keys { mod, "E" }, dsp_exec_cmd(programs.file_manager), { description = "Open file browser" })

hl.bind(keys { mod, "SHIFT", "Q" }, hl.dsp.window.close(), { description = "Close window" })
hl.bind(keys { mod, "CTRL", "Q" }, dsp_exec_cmd "hyprctl kill", { description = "Start kill mode" })

-- Screenshot
hl.bind("Print", dsp_exec_cmd(programs.printscreen), { description = "Take screenshot" })

-- Save Replay
hl.bind(
	keys { mod, "SHIFT", "R" },
	dsp_exec_cmd "killall -s SIGUSR1 gpu-screen-recorder",
	{ description = "Save gpu-screen-recorder replay clip" }
)

-- Clear Notifications
hl.bind(keys { mod, "CTRL", "SPACE" }, dsp_exec_cmd "makoctl dismiss -a", { description = "Dismiss all notifications" })

-- Toggle Waybar
hl.bind(keys { mod, "B" }, dsp_exec_cmd "killall -s SIGUSR1 -r waybar", { description = "Toggle waybar" })

-- Fullscreen / Maximise
hl.bind(keys { mod, "F" }, hl.dsp.window.fullscreen { mode = "fullscreen" }, { description = "Toggle fullscreen" })
hl.bind(keys { mod, "M" }, hl.dsp.window.fullscreen { mode = "maximized" }, { description = "Toggle maximise" })

-- Sticky
hl.bind(keys { mod, "SHIFT", "S" }, hl.dsp.window.pin {}, { description = "Toggle sticky mode" })

-- Toggle Floating
hl.bind(keys { mod, "SHIFT", "SPACE" }, hl.dsp.window.float {}, { description = "Toggle float mode" })

-- Exit/Logout
hl.bind(keys { mod, "SHIFT", "E" }, dsp_exec_cmd "wlogout", { description = "Open session actions" })
hl.bind(keys { mod, "CTRL", "L" }, dsp_exec_cmd "loginctl lock-session", { description = "Lock session" })

-- Clipboard Manager
hl.bind(
	keys { mod, "P" },
	dsp_exec_cmd 'cliphist list | fuzzel -p "Copy" --dmenu | cliphist decode | wl-copy',
	{ description = "Open clipboard history" }
)
hl.bind(
	keys { mod, "SHIFT", "P" },
	dsp_exec_cmd 'cliphist list | fuzzel -p "Delete from history" --dmenu | cliphist delete',
	{ description = "Delete item from clipboard history" }
)
hl.bind(keys { mod, "ALT", "P" }, dsp_exec_cmd "cliphist wipe", { description = "Wipe clipboard history" })

-- Brightness
hl.bind("XF86MonBrightnessUp", dsp_exec_cmd "brightnessctl set 10%+", { description = "Increase screen Brightness" })
hl.bind("XF86MonBrightnessDown", dsp_exec_cmd "brightnessctl set 10%-", { description = "Decrease screen Brightness" })

-- Audio
hl.bind(
	keys { "SHIFT", "XF86AudioMute" },
	dsp_exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
	{ description = "Toggle microphone mute" }
)

hl.bind(
	"XF86AudioRaiseVolume",
	dsp_exec_cmd "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+",
	{ repeating = true, locked = true, description = "Raise volume" }
)
hl.bind(
	"XF86AudioLowerVolume",
	dsp_exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
	{ repeating = true, locked = true, description = "Lower volume" }
)

hl.bind(
	keys { "ALT", "XF86AudioRaiseVolume" },
	dsp_exec_cmd "playerctl volume 0.1+",
	{ repeating = true, locked = true, description = "Raise player volume" }
)
hl.bind(
	keys { "ALT", "XF86AudioLowerVolume" },
	dsp_exec_cmd "playerctl volume 0.1-",
	{ repeating = true, locked = true, description = "Lower player volume" }
)

hl.bind("XF86AudioPlay", dsp_exec_cmd "playerctl play-pause", { locked = true, description = "Play/Pause player" })
hl.bind("XF86AudioStop", dsp_exec_cmd "playerctl stop", { locked = true, description = "Stop player" })
hl.bind(
	"XF86AudioPrev",
	dsp_exec_cmd "playerctl previous",
	{ locked = true, long_press = true, description = "Player Previous track" }
)
hl.bind(
	"XF86AudioNext",
	dsp_exec_cmd "playerctl next",
	{ locked = true, long_press = true, description = "Player next track" }
)
hl.bind(
	"XF86AudioPrev",
	dsp_exec_cmd "playerctl position 10-",
	{ locked = true, description = "Player skip backwards" }
)
hl.bind("XF86AudioNext", dsp_exec_cmd "playerctl position 10+", { locked = true, description = "Player skip forwards" })

-- Global Binds
hl.bind(keys { "ALT", "Pause" }, hl.dsp.pass { window = "class:(discord)" }, { description = "Toggle discord mute" })

-- Layout
hl.bind(keys { mod, "O" }, hl.dsp.window.pseudo {}, { description = "Toggle window pseudo-tiling" })
hl.bind(keys { mod, "S" }, hl.dsp.layout "togglesplit", { description = "Toggle window split direction" })
hl.bind(keys { mod, "SHIFT", "ALT", "H" }, hl.dsp.layout "preselect l", { description = "Preselect tiling left" })
hl.bind(keys { mod, "SHIFT", "ALT", "J" }, hl.dsp.layout "preselect d", { description = "Preselect tiling down" })
hl.bind(keys { mod, "SHIFT", "ALT", "K" }, hl.dsp.layout "preselect u", { description = "Preselect tiling up" })
hl.bind(keys { mod, "SHIFT", "ALT", "L" }, hl.dsp.layout "preselect r", { description = "Preselect tiling right" })

-- Tabs
hl.bind(keys { mod, "T" }, hl.dsp.group.toggle(), { description = "Toggle tab group" })
hl.bind(keys { mod, "ALT", "H" }, hl.dsp.group.prev(), { description = "Select previous tab" })
hl.bind(keys { mod, "ALT", "L" }, hl.dsp.group.next(), { description = "Select next tab" })

-- Window Focus
hl.bind(keys { mod, "H" }, hl.dsp.focus { direction = "l" }, { description = "Select window to the left" })
hl.bind(keys { mod, "J" }, hl.dsp.focus { direction = "d" }, { description = "Select window below" })
hl.bind(keys { mod, "K" }, hl.dsp.focus { direction = "u" }, { description = "Select window above" })
hl.bind(keys { mod, "L" }, hl.dsp.focus { direction = "r" }, { description = "Select window to the right" })

-- Move Window
hl.bind(
	keys { mod, "SHIFT", "H" },
	hl.dsp.window.move { direction = "l", group_aware = true },
	{ description = "Move window left" }
)
hl.bind(
	keys { mod, "SHIFT", "J" },
	hl.dsp.window.move { direction = "d", group_aware = true },
	{ description = "Move window down" }
)
hl.bind(
	keys { mod, "SHIFT", "K" },
	hl.dsp.window.move { direction = "u", group_aware = true },
	{ description = "Move window up" }
)
hl.bind(
	keys { mod, "SHIFT", "L" },
	hl.dsp.window.move { direction = "r", group_aware = true },
	{ description = "Move window right" }
)

-- Number Workspaces
for workspace = 1, 10 do
	local key = workspace % 10

	-- Change Workspace
	hl.bind(
		keys { mod, key },
		hl.dsp.focus { workspace = workspace },
		{ description = "Select workspace " .. workspace }
	)

	-- Move to Workspace
	hl.bind(
		keys { mod, "SHIFT", key },
		hl.dsp.window.move { workspace = workspace, follow = false },
		{ description = "Move window to workspace " .. workspace }
	)
end

-- Special Workspaces
hl.bind(keys { mod, "ALT", "M" }, hl.dsp.workspace.toggle_special "music", { description = "Toggle music workspace" })
hl.bind(
	keys { mod, "MINUS" },
	hl.dsp.workspace.toggle_special "scratchpad",
	{ description = "Toggle scratch workspace" }
)
hl.bind(
	keys { mod, "C" },
	hl.dsp.workspace.toggle_special "calculator",
	{ description = "Toggle calculator workspace" }
)
hl.bind(
	keys { "XF86Calculator" },
	hl.dsp.workspace.toggle_special "calculator",
	{ description = "Toggle calculator workspace" }
)
hl.bind(
	keys { mod, "R" },
	hl.dsp.workspace.toggle_special "screen-record",
	{ description = "Toggle screen-record workspace" }
)
hl.bind(
	keys { mod, "EQUAL" },
	dsp_exec_cmd "hyprctl workspaces -j | jq -r '.[] | .name' | fuzzel --dmenu | xargs -I {} hyprctl dispatch 'hl.dsp.focus { workspace = \"name:{}\" }'",
	{ description = "Select workspace from list" }
)

hl.bind(
	keys { mod, "SHIFT", "MINUS" },
	hl.dsp.window.move { workspace = "special:scratchpad", follow = false },
	{ description = "Move window to scratchpad" }
)
hl.bind(
	keys { mod, "SHIFT", "EQUAL" },
	dsp_exec_cmd "hyprctl workspaces -j | jq -r '.[] | .name' | fuzzel --dmenu | xargs -I {} hyprctl dispatch 'hl.dsp.window.move { workspace = \"name:{}\", follow = false }'",
	{ description = "Move window to workspace from list" }
)

-- Mouse Binds
hl.bind(keys { mod, "mouse:272" }, hl.dsp.window.drag(), { mouse = true, description = "Drag window" })
hl.bind(keys { mod, "mouse:273" }, hl.dsp.window.resize(), { mouse = true, description = "Resize window" })
