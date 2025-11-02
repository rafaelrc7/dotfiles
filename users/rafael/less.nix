{
  lib,
  config,
  pkgs,
  ...
}:
let
  pygmentize-style =
    if config.catppuccin.enable then "catppuccin-${config.catppuccin.flavor}" else "vim";
  pygmentize = pkgs.python3Packages.pygments.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.makeWrapper ];
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ pkgs.python3Packages.catppuccin ];
    postInstall = ''
      wrapProgram $out/bin/pygmentize \
        --add-flags "-O style=${pygmentize-style}"
    '';
  });
  lesspipe = pkgs.lesspipe.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/lesspipe.sh \
        --prefix PATH : ${lib.makeBinPath [ pygmentize ]}
    '';
  });
in
{
  programs.less.enable = true;
  programs.lesspipe = {
    enable = true;
    package = lesspipe;
  };

  home.sessionVariables =
    let
      tput = "${pkgs.ncurses}/bin/tput";
    in
    {
      LESS = " -R ";
      LESS_TERMCAP_mb = "$(${tput} bold; ${tput} setaf 2)"; # green
      LESS_TERMCAP_md = "$(${tput} bold; ${tput} setaf 6)"; # cyan
      LESS_TERMCAP_me = "$(${tput} sgr0)";
      LESS_TERMCAP_so = "$(${tput} bold; ${tput} setaf 3; ${tput} setab 4)"; # yellow on blue
      LESS_TERMCAP_se = "$(${tput} rmso; ${tput} sgr0)";
      LESS_TERMCAP_us = "$(${tput} smul; ${tput} bold; ${tput} setaf 7)"; # white
      LESS_TERMCAP_ue = "$(${tput} rmul; ${tput} sgr0)";
      LESS_TERMCAP_mr = "$(${tput} rev)";
      LESS_TERMCAP_mh = "$(${tput} dim)";
      LESS_TERMCAP_ZN = "$(${tput} ssubm)";
      LESS_TERMCAP_ZV = "$(${tput} rsubm)";
      LESS_TERMCAP_ZO = "$(${tput} ssupm)";
      LESS_TERMCAP_ZW = "$(${tput} rsupm)";
      MANPAGER = "${config.programs.less.package}/bin/less";
      MANROFFOPT = "-P -c";
    };
}
