{ self, ... }:
{ inputs, config, pkgs, ... }: {

  home.username = "rafael";
  home.homeDirectory = "/home/rafael";

  programs.home-manager.enable = true;

  imports = [
    inputs.nix-colors.homeManagerModule
    inputs.wayland-pipewire-idle-inhibit.homeModules.default
    ./environment_variables.nix

    ./crypto.nix
    ./git.nix
    ./go.nix
    ./gui-pkgs.nix
    ./gui-theme.nix
    ./gschemas.nix
    ./jetbrains.nix
    ./kitty.nix
    ./mpd.nix
    ./neomutt.nix
    ./email.nix
    ./neovim.nix
    ./node.nix
    ./pass.nix
    ./syncthing.nix
    ./sway.nix
    ./vscode.nix
    ./waybar.nix
    ./xdg.nix
    ./zsh.nix
  ];

  colorscheme = inputs.nix-colors.colorSchemes.dracula;

  home.packages = with pkgs; [
    feh
    fzf
    neovim-qt
    ripgrep
    zathura
    gcr # needed by gnome-keyring
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

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  services.keybase.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}

