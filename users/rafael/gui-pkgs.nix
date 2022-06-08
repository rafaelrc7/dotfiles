{ pkgs, ... }: {
  home.packages = with pkgs; [
    discord
    gimp
    gparted
    jetbrains.idea-ultimate
    libreoffice-fresh
    librewolf
    obs-studio
    pavucontrol
    pcmanfm
    slack
    tdesktop
    thunderbird
    ungoogled-chromium
    unityhub
    v4l-utils
    zoom-us
  ];

  home.file.".librewolf/native-messaging-hosts/passff.json".source =
    "${pkgs.passff-host}/share/passff-host/passff.json";

  home.sessionVariables.SSH_ASKPASS =
    "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";

  home.file.".xprofile".text = ''
    [ -e $HOME/.zshenv ] && . $HOME/.zshenv
    [ -e $HOME/.profile ] && . $HOME/.profile
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

