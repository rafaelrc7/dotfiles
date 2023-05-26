{ pkgs, ... }: let
  pass-otp = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
in {
  home.packages = with pkgs; [
    (discord.override { nss = nss_latest; })
    (discord-canary.override { nss = nss_latest; })
    calibre
    gimp
    gparted
    libreoffice-fresh
    librewolf firefox
    obs-studio
    pavucontrol
    pcmanfm
    slack
    spotify
    tdesktop
    thunderbird protonmail-bridge
    ungoogled-chromium
    unityhub
    v4l-utils
    zoom-us
  ];

  home.file.".librewolf/native-messaging-hosts/passff.json".source =
    "${pkgs.passff-host.override {pass = pass-otp;}}/share/passff-host/passff.json";

  home.file.".librewolf/native-messaging-hosts/ff2mpv.json".source =
    "${pkgs.ff2mpv}/lib/mozilla/native-messaging-hosts/ff2mpv.json";

  home.sessionVariables.SSH_ASKPASS =
    "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";

  home.file.".xprofile".text = ''
    #!/bin/sh
    [ -e $HOME/.zshenv ] && . $HOME/.zshenv
    [ -e $HOME/.profile ] && . $HOME/.profile

    # nix flatpak fix for opening links and other non-flatpak default apps
    sh -c "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service" &
  '';

  services.unclutter = {
    enable = true;
    timeout = 3;
  };

  services.flameshot = {
    enable = true;
    settings = {
      General.showStartupLaunchMessage = false;
    };
  };

  programs.mpv = {
    enable = true;
  };
}

