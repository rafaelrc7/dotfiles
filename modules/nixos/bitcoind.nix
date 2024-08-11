{ ... }: {
  services.bitcoind.main = {
    enable = true;
    prune = 5120;
    extraConfig = ''
      server=1
      listen=1

      proxy=127.0.0.1:9050
      bind=127.0.0.1

      onlynet=onion
    '';
  };

  services.tor = {
    enable = true;
    client.enable = true;
    controlSocket.enable = true;
    settings = {
      CookieAuthentication = true;
      CookieAuthFileGroupReadable = true;
    };
  };
}

