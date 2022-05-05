{ config, pkgs, ... }: {
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "librewolf";
    TERMINAL = "kitty";

    IDEA_JDK     = "${pkgs.jetbrains.jdk}";
    PHPSTORM_JDK = "${pkgs.jetbrains.jdk}";
    WEBIDE_JDK   = "${pkgs.jetbrains.jdk}";
    PYCHARM_JDK  = "${pkgs.jetbrains.jdk}";
    RUBYMINE_JDK = "${pkgs.jetbrains.jdk}";
    CL_JDK       = "${pkgs.jetbrains.jdk}";
    DATAGRIP_JDK = "${pkgs.jetbrains.jdk}";
    GOLAND_JDK   = "${pkgs.jetbrains.jdk}";
    STUDIO_JDK   = "${pkgs.jetbrains.jdk}";
  };
}

