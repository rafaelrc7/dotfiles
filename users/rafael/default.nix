{ self, ... }:
{ crypto ? self.homeModules.crypto
, go ? self.homeModules.go
, gschemas ? self.homeModules.gschemas
, jetbrains ? self.homeModules.jetbrains
, kitty ? self.homeModules.kitty
, mpd ? self.homeModules.mpd
, node ? self.homeModules.node
, pass ? self.homeModules.pass
, protonmail-bridge ? self.homeModules.protonmail-bridge
, syncthing ? self.homeModules.syncthing
, email ? ./email.nix
, environment_variables ? ./environment_variables.nix
, git ? ./git.nix
, gui-pkgs ? ./gui-pkgs.nix
, gui-theme ? ./gui-theme.nix
, neomutt ? ./neomutt.nix
, neovim ? ./neovim.nix
, sway ? ./sway.nix
, vscode ? ./vscode.nix
, waybar ? ./waybar.nix
, xdg ? ./xdg.nix
, zsh ? ./zsh.nix
}:
{ inputs, config, lib, pkgs, ... }: {

  home.username = lib.mkDefault "rafael";
  home.homeDirectory = lib.mkDefault "/home/rafael";

  programs.home-manager.enable = true;

  imports = with self.lib; optionalsNotNull [
    crypto
    go
    gschemas
    jetbrains
    kitty
    mpd
    node
    pass
    protonmail-bridge
    syncthing

    email
    environment_variables
    git
    gui-pkgs
    gui-theme
    neomutt
    neovim
    sway
    vscode
    waybar
    xdg
    zsh

    inputs.nix-colors.homeManagerModule
    inputs.wayland-pipewire-idle-inhibit.homeModules.default
  ];

  colorScheme = inputs.nix-colors.colorSchemes.dracula;

  home.packages = with pkgs; [
    fzf
    neovim-qt
    ripgrep
    gcr
  ];

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.shellAliases = {
    diff = "diff --color=auto";
    dmesg = "dmesg --color=always";
    grep = "grep --color=auto";
    ip = "ip --color=auto";
    ls = "ls --color=auto";
    sudo = "sudo "; # Makes commands after sudo keep colour
    matlab = "nix run gitlab:doronbehar/nix-matlab";
    nixsh = "nix shell";
    rm = "rm -I";
    mv = "mv -i";
    ssh = "TERM=xterm-256color ssh";
  };

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "aur.archlinux.org" = {
        identityFile = "${config.home.homeDirectory}/.ssh/aur";
        user = "aur";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentryFlavor = "gnome3";
    sshKeys = [
      "94C7C77450894FC856B6C3121A9232BC13054C83"
    ];
  };

  programs.password-store.settings = {
    PASSWORD_STORE_KEY = "081F97AC49F2CA9548DB08E7091BB8A361C7B4EB";
    PASSWORD_STORE_DIR = "$HOME/.password-store";
  };

  services.keybase.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}

