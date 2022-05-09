{ inputs, pkgs, ... }: {
  services.xserver = {
    windowManager.awesome = {
      enable = true;
      package = (pkgs.awesome.overrideAttrs (old: {
        version = "git";
        src = inputs.awesome-git;
      })).override { lua = pkgs.lua5_3; };
    };

    layout = "us";
  };
}

