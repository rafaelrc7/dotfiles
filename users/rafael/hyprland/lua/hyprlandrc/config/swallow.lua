hl.config {
	misc = {
		enable_swallow = true,
		swallow_regex = "^(kitty|footclient|foot)$",
		swallow_exception_regex = "^(nix run nixpkgs##)?(ssh.*|wev|(xorg.)?xev)$",
	},
}
