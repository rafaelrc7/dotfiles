{
  homeProfiles,
  profiles,
  extraModules ? [ ],
  gui ? true,
  ...
}:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) optionals;
  defaultProfiles = with homeProfiles; base ++ dev ++ pc;
  profiles' = (if profiles == null then defaultProfiles else profiles);
in
{
  home.username = "desenvolvedor";
  home.homeDirectory = "/home/desenvolvedor";

  targets.genericLinux.enable = true;
  targets.genericLinux.gpu.enable = true;

  programs.home-manager.enable = true;

  imports =
    extraModules
    ++ profiles'
    ++ optionals gui (
      homeProfiles.gui
      ++ [
        ./gui-pkgs.nix
      ]
    )
    ++ [
      ../rafael/email-accounts
      ../rafael/environment_variables.nix
      ../rafael/git.nix
      ../rafael/neovim
      ../rafael/ssh.nix
      ../rafael/theme.nix
      ../rafael/xdg-mimeapps.nix
      ../rafael/zsh.nix
      ./less.nix
    ];

  home.packages = with pkgs; [
    (neovim-qt.override { neovim = config.programs.neovim.finalPackage; })
    nh
    trash-cli
  ];

  programs.fzf.enable = true;
  programs.ripgrep.enable = true;

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
    setSessionVariables = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-gnome3;
    sshKeys = [
      "94C7C77450894FC856B6C3121A9232BC13054C83"
    ];
  };

  home.sessionVariables.SSH_ASKPASS = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";

  programs.password-store.settings = {
    PASSWORD_STORE_KEY = "081F97AC49F2CA9548DB08E7091BB8A361C7B4EB";
  };

  home.file.".xprofile".text = ''
    #!/bin/sh
    [ -e $HOME/.zshenv ] && . $HOME/.zshenv
    [ -e $HOME/.profile ] && . $HOME/.profile

    # nix flatpak fix for opening links and other non-flatpak default apps
    sh -c "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service" &
  '';

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
