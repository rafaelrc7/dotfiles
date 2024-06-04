{ pkgs, ... }: {
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  home.packages = with pkgs; [
    gcr # needed by gnome-keyring
    gnome.gnome-keyring
    libsecret
  ];

  xdg.portal.config = {
    common = {
      "org.freedesktop.impl.portal.Secret" = [
        "gnome-keyring"
      ];
    };
  };
}

