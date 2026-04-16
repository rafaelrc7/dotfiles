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

  home.sessionVariables = {
    LESS = " -R ";
    MANPAGER = "${config.programs.less.package}/bin/less";
    MANROFFOPT = "-P -c";
  };
}
