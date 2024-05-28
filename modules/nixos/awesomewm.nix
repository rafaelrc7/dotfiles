{ inputs, pkgs, ... }: {
  services.xserver = {
    windowManager.awesome = {
      enable = true;
      package = (pkgs.awesome.overrideAttrs (old: {
        version = "git";
        src = inputs.awesome-git;
        patches = [ ];
        postPatch = ''
          chmod +x /build/source/tests/examples/_postprocess.lua
          patchShebangs /build/source/tests/examples/_postprocess.lua
        '';
      })).override { lua = pkgs.lua5_3; };
    };
  };
}

