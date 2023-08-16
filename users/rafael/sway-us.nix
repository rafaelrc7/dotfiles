{ pkgs, lib, ... }: {
  wayland.windowManager.sway = {
    config = {
      input = {
        "*" = {
          xkb_layout = "us";
        };
      };
    };
  };
}

