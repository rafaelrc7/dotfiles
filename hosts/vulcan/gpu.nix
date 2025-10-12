{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware = {
    amdgpu.initrd.enable = true;
    amdgpu.opencl.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in
    [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];

  environment = {
    systemPackages = with pkgs; [
      libva-utils
      glxinfo
    ];
  };

  services.ollama = {
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.2";
  };
}
