{ pkgs, ... }: {
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [ gnome-keyring gcr libsecret ];
  xdg.portal.config = {
    common = {
      "org.freedesktop.impl.portal.Secret" = [
        "gnome-keyring"
      ];
    };
  };
}

