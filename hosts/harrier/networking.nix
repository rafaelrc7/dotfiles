{ lib, ... }: {
  networking = {
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };

    wireless.iwd.enable = true;
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

    networks = {
      "10-bond0" = {
        enable = true;
        matchConfig.Name = "bond0";
        DHCP = "no";
        gateway = [ "10.0.0.1" ];
        address = [ "10.0.0.20/24" ];
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
          DNSSEC = true;
        };
        dns = [ "127.0.0.1" "::1" ];
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
  };
}

