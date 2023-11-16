{ pkgs, ... }: let
  pass-otp = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
in {
  home.packages = with pkgs; [
    (discord.override { nss = nss_latest; })
    calibre
    gimp
    gparted
    libreoffice-fresh
    librewolf firefox
    pavucontrol
    pcmanfm dolphin
    spotify
    tdesktop
    obsidian
    ungoogled-chromium
    v4l-utils
    zoom-us
  ];

  imports = [
    ./thunderbird-protonmail.nix
  ];

  home.file.".librewolf/native-messaging-hosts/passff.json".source =
    "${pkgs.passff-host.override {pass = pass-otp;}}/share/passff-host/passff.json";

  home.file.".librewolf/native-messaging-hosts/ff2mpv.json".source =
    "${pkgs.ff2mpv}/lib/mozilla/native-messaging-hosts/ff2mpv.json";

  home.file.".librewolf/librewolf.overrides.cfg".text = ''
    defaultPref("media.eme.enabled", true);
    defaultPref("media.gmp-widevinecdm.visible", true);
    defaultPref("media.gmp-widevinecdm.enabled", true);
    defaultPref("media.gmp-provider.enabled", true);
    defaultPref("media.gmp-manager.url", "https://aus5.mozilla.org/update/3/GMP/%VERSION%/%BUILD_ID%/%BUILD_TARGET%/%LOCALE%/%CHANNEL%/%OS_VERSION%/%DISTRIBUTION%/%DISTRIBUTION_VERSION%/update.xml");

    defaultPref("webgl.disabled", false);
    defaultPref("webgl.enable-webgl2", true);
    defaultPref("media.ffmpeg.vaapi.enabled", true)

    defaultPref("ui.context_menus.after_mouseup", true);
    defaultPref("browser.compactmode.show", true);
    defaultPref("browser.download.start_downloads_in_tmp_dir", true);
  '';

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
    enable = false;
    settings = {
      General.showStartupLaunchMessage = false;
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
    };
    scripts = with pkgs.mpvScripts; [
      mpris
      sponsorblock
      webtorrent-mpv-hook
    ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
    ];
  };
}

