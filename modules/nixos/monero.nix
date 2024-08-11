{ ... }: {
  services.monero = {
    enable = true;
    extraConfig = ''
      prune-blockchain=1
      sync-pruned-blocks=1
      db-sync-mode=safe
      confirm-external-bind=1
    '';
  };
}

