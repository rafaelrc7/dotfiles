{ self, inputs }:
let
  inherit (inputs) nixpkgs;
  users = [
    {
      name = "rafael";
      extraGroups = [
        "wheel"
        "adbusers"
        "libvirtd"
        "dialout"
        "podman"
      ];
      sshKeys = import ../../users/rafael/sshkeys.nix;
      extraArgs = {
        crypto = null;
        email = null;
        firefox = null;
        go = null;
        gschemas = null;
        gui-pkgs = null;
        hyprland = null;
        jetbrains = null;
        kitty = null;
        librewolf = null;
        mpd = null;
        mpv = null;
        neomutt = null;
        node = null;
        protonmail-bridge = null;
        rclone-gdrive = null;
        sway = null;
        udiskie = null;
        obs = null;
        vscode = null;
        zathura = null;
      };
    }
  ];
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    inherit inputs;
    inherit (self) nixosModules nixosProfiles;
    inherit (inputs) home-manager nur nixos-hardware;
  };
  modules = [
    (import ./configuration.nix)
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
    (self.lib.nixpkgsConfig { })

    (self.lib.mkUsers users)
    {
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        extraSpecialArgs = { inherit inputs nixpkgs self; };
        users = self.lib.mkHMUsers users;
      };
    }
  ];
}
