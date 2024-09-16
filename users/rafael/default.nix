{ self, ... }:
{ crypto ? self.homeModules.crypto
, email ? ./email.nix
, environment_variables ? ./environment_variables.nix
, firefox ? self.homeModules.firefox
, git ? ./git.nix
, gnome-keyring ? self.homeModules.gnome-keyring
, go ? self.homeModules.go
, gschemas ? self.homeModules.gschemas
, gui-pkgs ? ./gui-pkgs.nix
, theme ? ./theme.nix
, hyprland ? ./hyprland.nix
, jetbrains ? self.homeModules.jetbrains
, keybase ? self.homeModules.keybase
, kitty ? self.homeModules.kitty
, librewolf ? self.homeModules.librewolf
, mpd ? self.homeModules.mpd
, mpv ? self.homeModules.mpv
, neomutt ? ./neomutt.nix
, neovim ? ./neovim
, nix ? self.homeModules.nix
, node ? self.homeModules.node
, pass ? self.homeModules.pass
, protonmail-bridge ? self.homeModules.protonmail-bridge
, rclone-gdrive ? self.homeModules.rclone-gdrive
, syncthing ? self.homeModules.syncthing
, sway ? ./sway.nix
, tmux ? ./tmux.nix
, udiskie ? self.homeModules.udiskie
, obs ? self.homeModules.obs
, vscode ? ./vscode.nix
, xdg ? ./xdg.nix
, zathura ? self.homeModules.zathura
, zsh ? ./zsh.nix
}:
{ inputs, config, lib, pkgs, ... }: {

  home.username = lib.mkDefault "rafael";
  home.homeDirectory = lib.mkDefault "/home/rafael";

  programs.home-manager.enable = true;

  imports = self.lib.optionalsNotNull [
    crypto
    firefox
    gnome-keyring
    go
    gschemas
    jetbrains
    keybase
    kitty
    librewolf
    mpd
    mpv
    nix
    node
    obs
    pass
    protonmail-bridge
    rclone-gdrive
    syncthing
    tmux
    udiskie

    email
    environment_variables
    git
    gui-pkgs
    theme
    hyprland
    neomutt
    neovim
    sway
    vscode
    xdg
    zathura
    zsh

    inputs.wayland-pipewire-idle-inhibit.homeModules.default
  ];

  home.packages = with pkgs; [
    neovim-qt
  ];

  programs.btop.enable = true;
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
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "aur.archlinux.org" = {
        identityFile = "${config.home.homeDirectory}/.ssh/aur";
        user = "aur";
      };
    };

    extraConfig = ''
      XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
    '';
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    sshKeys = [
      "94C7C77450894FC856B6C3121A9232BC13054C83"
    ];
  };

  home.sessionVariables.SSH_ASKPASS =
    "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";

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

