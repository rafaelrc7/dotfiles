{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    powerManagement.enable = true;
    videoAcceleration = true;
  };

  hardware.nvidia.prime.offload.enable = false;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      libva-utils
      mesa-demos
      nvtopPackages.nvidia
      egl-wayland
    ];
  };

  services.ollama.package = pkgs.ollama-cuda;
}
