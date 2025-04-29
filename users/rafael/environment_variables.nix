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
  };
}
