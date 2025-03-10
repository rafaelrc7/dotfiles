{ config, ... }:
{
  systemd.user.sessionVariables = config.home.sessionVariables;
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    EXPLORER = "dolphin";

    CABAL_DIR = "$HOME/.local/share/cabal";
    CABAL_CONFIG = "$HOME/.config/cabal/config";
    CABAL_BUILDDIR = "$HOME/.cache/cabal";

    LESS = "-R";
    LESS_TERMCAP_mb = "$'\E[1;31m'"; # begin blink
    LESS_TERMCAP_md = "$'\E[1;36m'"; # begin bold
    LESS_TERMCAP_me = "$'\E[0m'"; # reset bold/blink
    LESS_TERMCAP_so = "$'\E[01;44;33m'"; # begin reverse video
    LESS_TERMCAP_se = "$'\E[0m'"; # reset reverse video
    LESS_TERMCAP_us = "$'\E[1;32m'"; # begin underline
    LESS_TERMCAP_ue = "$'\E[0m'"; # reset underline
  };
}
