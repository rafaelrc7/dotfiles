{ pkgs, ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        amdvlk

        libvdpau-va-gl
        libva-vdpau-driver

        rocmPackages.clr
        rocmPackages.clr.icd
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        amdvlk

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
