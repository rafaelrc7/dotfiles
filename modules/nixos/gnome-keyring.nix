{ pkgs, ... }: {
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [ gnome.gnome-keyring gcr libsecret ];
}

