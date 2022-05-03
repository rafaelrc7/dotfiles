{ ... }: {
  networking = {
    nameservers = [ "127.0.0.1" "::1" ];
    resolvconf.enable = false;
    dhcpcd.extraConfig = "nohook resolve.conf";
    networkmanager.dns = "none";
  };

  services.resolved.enable = false;

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      log_file = "/var/log/dnscrypt-proxy2/log";
      log_file_latest = true;

      ipv6_servers = true;
      dnscrypt_servers = true;
      doh_servers = true;
      require_dnssec = true;
    };
  };
}

