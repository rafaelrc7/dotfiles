{ ... }: {
  services.monero = {
    enable = true;
    extraConfig = ''
      db-sync-mode=safe
      confirm-external-bind=1
    '';
  };
}

