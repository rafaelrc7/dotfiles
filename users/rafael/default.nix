{ self, ... }:
{ inputs, config, pkgs, ... }: {

  home.username = "rafael";
  home.homeDirectory = "/home/rafael";

  programs.home-manager.enable = true;

  imports = with self.homeModules; [
    crypto
    gnome-keyring
    go
    gschemas
    jetbrains
    kitty
    mpd
    node
    pass
    syncthing

    ./email.nix
    ./environment_variables.nix
    ./git.nix
    ./gui-pkgs.nix
    ./gui-theme.nix
    ./neomutt.nix
    ./neovim.nix
    ./sway.nix
    ./vscode.nix
    ./waybar.nix
    ./xdg.nix
    ./zsh.nix

    inputs.nix-colors.homeManagerModule
    inputs.wayland-pipewire-idle-inhibit.homeModules.default
  ];

  colorScheme = inputs.nix-colors.colorSchemes.dracula;

  home.packages = with pkgs; [
    feh
    fzf
    neovim-qt
    ripgrep
  ];

  home.sessionPath = [ "$HOME/.local/bin" ];

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
    pinentryFlavor = "qt";
    sshKeys = [
      "94C7C77450894FC856B6C3121A9232BC13054C83"
    ];
  };

  services.keybase.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}

