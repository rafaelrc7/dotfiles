{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware = {
    amdgpu.initrd.enable = true;
    amdgpu.opencl.enable = true;

    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        libva-vdpau-driver
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        libvdpau-va-gl
        libva-vdpau-driver
      ];
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
