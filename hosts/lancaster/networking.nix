{ ... }:
{
  networking = {
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        18081 # monero RPC
      ];
      allowedUDPPorts = [
        8211 # PalWorld
        7777
        27015
        27016 # Steam
      ];
    };
  };

  systemd.network = {
    enable = true;

    wait-online.anyInterface = true;

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
        address = [ "10.0.0.30/24" ];
        dhcpV4Config = {
          UseDNS = false;
          Anonymize = true;
          UseDomains = false;
        };
        dhcpV6Config = {
          UseDNS = false;
        };
        networkConfig = {
          IPv6PrivacyExtensions = true;
          DNSSEC = false;
        };
        dns = [ "10.0.0.20" ];
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
