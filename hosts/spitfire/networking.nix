{ ... }:
{
  networking = {
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        8010 # VLC Chromecast
        11470 # Stremio
      ];
      allowedUDPPorts = [ ];
    };

    wireless.iwd.enable = true;
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
      "10-bond0" = {
        enable = true;
        netdevConfig = {
          Name = "bond0";
          Kind = "bond";
        };
        bondConfig = {
          Mode = "active-backup";
          PrimaryReselectPolicy = "always";
          MIIMonitorSec = "1s";
        };
      };
    };

    networks = {
      "10-bond0" = {
        enable = true;
        matchConfig.Name = "bond0";
        DHCP = "yes";
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
        dns = [
          "10.0.0.20"
          "1.1.1.1"
          "1.0.0.1"
        ];
      };

      "10-ethernet-bond0" = {
        enable = true;
        matchConfig.Type = "ether";
        bond = [ "bond0" ];
        networkConfig.PrimarySlave = true;
      };

      "10-wifi-bond0" = {
        enable = true;
        matchConfig.Type = "wlan";
        bond = [ "bond0" ];
      };
    };
  };
}
