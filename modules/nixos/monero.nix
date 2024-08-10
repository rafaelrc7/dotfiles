{ ... }: {
  # Monero RPC Port
  networking.firewall.allowedTCPPorts = [ 18081 ];

  services.monero = {
    enable = true;
    extraConfig = ''
      prune-blockchain=1
      sync-pruned-blocks=1
      db-sync-mode=safe
      confirm-external-bind=1
    '';
    rpc = {
      address = "100.120.92.101"; # tailscale IP
    };
  };
}

