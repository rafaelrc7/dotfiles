{ lib, ... }: {

  security.rtkit.enable = true;
  services.pulseaudio.enable = lib.mkForce false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber = {
      enable = true;

      # Temporary fix to wireplumber keeping camera powered
      # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/2669
      extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = {
            main = {
              "monitor.libcamera" = "disabled";
            };
          };
        };
      };
    };
  };
}

