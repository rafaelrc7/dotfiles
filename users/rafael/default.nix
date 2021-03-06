{ inputs, config, pkgs, ... }: {

  home.username = "rafael";
  home.homeDirectory = "/home/rafael";

  programs.home-manager.enable = true;

  imports = [
    inputs.nix-colors.homeManagerModule
    ./environment_variables.nix
  ];

  colorscheme = inputs.nix-colors.colorSchemes.nord;

  home.packages = with pkgs; [
    gcc
    ripgrep
    speedtest-cli
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
        identityFile = "$HOME/.ssh/aur";
        user = "aur";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    sshKeys = [
      "72C0B9E758F6099D4F7F6B4B44E4DD530867E7A9"
    ];
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.05";
}

