-- Floating Steam Dialogs
hl.window_rule {
	match = { class = "(steam)" },
	float = true,
}
hl.window_rule {
	match = { class = "(steam)", title = "(Friends List)" },
	float = false,
}
hl.window_rule {
	match = { class = "(steam)", title = "(Steam)" },
	float = false,
}

-- Steam Games
hl.window_rule {
	match = { class = "(steam_app.*)" },
	border_size = 0,
	rounding = 0,
	stay_focused = true,
}

-- Paradox Launcher
hl.window_rule {
	match = { class = "(Paradox Launcher)" },
	float = true,
	center = true,
	keep_aspect_ratio = true,
}

-- Floating Firefox Picture-in-Picture
hl.window_rule {
	match = { class = "(firefox)", title = "(Picture-in-Picture)" },
	float = true,
	keep_aspect_ratio = true,
}

-- Flameshot
hl.window_rule {
	match = { title = "flameshot" },
	pin = true,
	no_anim = true,
	stay_focused = true,
	suppress_event = "fullscreen",
	float = true,
	monitor = 0,
	move = { 0, 0 },
	border_size = 0,
	rounding = 0,
}

-- Password Entry Dialogs
hl.window_rule {
	match = { class = "(pinentry-)(.*)" },
	stay_focused = true,
	no_screen_share = true,
}
hl.window_rule {
	match = { class = "(polkit-)(.*)", title = "(Authenticate)" },
	stay_focused = true,
	no_screen_share = true,
}
hl.window_rule {
	match = { class = "(gcr-prompter)" },
	stay_focused = true,
	no_screen_share = true,
}

-- qalculate-qt
hl.window_rule {
	match = { class = "^(io.github.Qalculate.qalculate-qt)$" },
	float = true,
}

-- Spotify to music workspace
hl.window_rule {
	match = { class = "(spotify)" },
	workspace = "special music",
}

-- No border on floating windows
hl.window_rule {
	match = { float = true },
	border_size = 0,
}

-- Floating on special workspaces
hl.window_rule {
	match = { workspace = "n[s:special:scratchpad]" },
	float = true,
}
hl.window_rule {
	match = { workspace = "n[s:special:calculator]" },
	float = true,
}
hl.window_rule {
	match = { workspace = "n[s:special:screen-record]" },
	float = true,
}
