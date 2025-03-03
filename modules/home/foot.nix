{ ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "no";
      };

      cursor = {
        style = "beam";
        blink = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
