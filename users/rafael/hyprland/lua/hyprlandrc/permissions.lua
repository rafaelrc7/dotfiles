hl.config { ecosystem = { enforce_permissions = true } }

hl.permission { binary = "/nix/store/[a-z0-9]{32}-grim-[0-9.]*/bin/grim", type = "screencopy", mode = "allow" }
hl.permission { binary = "/nix/store/[a-z0-9]{32}-hyprlock-[0-9.]*/bin/hyprlock", type = "screencopy", mode = "allow" }
hl.permission {
	binary = "/nix/store/[a-z0-9]{32}-xdg-desktop-portal-hyprland-[0-9.]*(\\+date=[0-9-]*_[a-z0-9]{7})?/libexec/.xdg-desktop-portal-hyprland-wrapped",
	type = "screencopy",
	mode = "allow",
}
