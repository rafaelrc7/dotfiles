{ config, pkgs, ... }: {
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "librewolf";
    TERMINAL = "kitty";
    EXPLORER = "${pkgs.pcmanfm}";

    IDEA_JDK     = "${pkgs.jetbrains.jdk}";
    PHPSTORM_JDK = "${pkgs.jetbrains.jdk}";
    WEBIDE_JDK   = "${pkgs.jetbrains.jdk}";
    PYCHARM_JDK  = "${pkgs.jetbrains.jdk}";
    RUBYMINE_JDK = "${pkgs.jetbrains.jdk}";
    CL_JDK       = "${pkgs.jetbrains.jdk}";
    DATAGRIP_JDK = "${pkgs.jetbrains.jdk}";
    GOLAND_JDK   = "${pkgs.jetbrains.jdk}";
    STUDIO_JDK   = "${pkgs.jetbrains.jdk}";

    LESS  = "-R";
    LESS_TERMCAP_mb = "$'\E[1;31m'";     # begin blink
    LESS_TERMCAP_md = "$'\E[1;36m'";     # begin bold
    LESS_TERMCAP_me = "$'\E[0m'";        # reset bold/blink
    LESS_TERMCAP_so = "$'\E[01;44;33m'"; # begin reverse video
    LESS_TERMCAP_se = "$'\E[0m'";        # reset reverse video
    LESS_TERMCAP_us = "$'\E[1;32m'";     # begin underline
    LESS_TERMCAP_ue = "$'\E[0m'";        # reset underline
  };
}

