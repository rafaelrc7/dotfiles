{ ... }:
{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    shellIntegration.enableBashIntegration = true;
    settings = {
      enable_audio_bell = false;
      scrollback_pager_history_size = 2048;
      mouse_map = "left click ungrabbed no-op";
    };
  };
}
