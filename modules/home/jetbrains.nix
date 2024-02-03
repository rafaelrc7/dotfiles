{ pkgs, ... }: {
  home.packages = with pkgs.jetbrains; [
    idea-ultimate
  ];

  home.sessionVariables = with pkgs.jetbrains; {
    IDEA_JDK = "${jdk}";
    PHPSTORM_JDK = "${jdk}";
    WEBIDE_JDK = "${jdk}";
    PYCHARM_JDK = "${jdk}";
    RUBYMINE_JDK = "${jdk}";
    CL_JDK = "${jdk}";
    DATAGRIP_JDK = "${jdk}";
    GOLAND_JDK = "${jdk}";
    STUDIO_JDK = "${jdk}";
  };
}

