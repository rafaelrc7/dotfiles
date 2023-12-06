{ ... }: {
  networking = {
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 25565 9512 7240 7241 7242 43157 ];
      allowedUDPPorts = [       9512 7240 7241 7242 43157 ];
    };
  };

  systemd.network = {
    enable = true;

    links = {
      "00-random-mac" = {
        enable = true;
        matchConfig.OriginalName = "*";
        linkConfig.MACAddressPolicy = "random";
      };
    };

    netdevs = {
      "10-br0" = {
        enable = true;
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };
    };

    networks = {
      "10-br0" = {
        enable = true;
        matchConfig.Name = "br0";
        DHCP = "no";
        gateway = [ "10.0.0.1" ];
        address = [ "10.0.0.10/24" ];
        dhcpV4Config = {
          UseDNS = false;
          Anonymize = true;
          UseDomains= false;
        };
        dhcpV6Config = {
          UseDNS = false;
        };
        networkConfig = {
          IPv6PrivacyExtensions = true;
          DNSSEC = false;
        };
        dns = [ "10.0.0.20" "1.1.1.1" "1.0.0.1" ];
      };

      "10-eth0" = {
        enable = true;
        matchConfig.Type = "ether";
        bridge = [ "br0" ];
        networkConfig.PrimarySlave = true;
      };
    };
  };
}

