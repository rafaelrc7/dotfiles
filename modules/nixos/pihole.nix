{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [
    53
    80
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.dnscrypt-proxy2.settings.listen_addresses = [
    "127.0.0.1:5353"
    "[::1]:5353"
  ];

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:2022.05";
    volumes = [
      "/etc/pihole:/etc/pihole"
      "/etc/dnsmasq.d:/etc/dnsmasq.d"
    ];
    ports = [
      "53:53/udp"
      "53:53/tcp"
      "80:80/tcp"
    ];
    environment = {
      TZ = config.time.timeZone;
      #WEBPASSWORD = "random";
      #VIRTUAL_HOST = "10.0.0.95";
      PIHOLE_DNS_ = "127.0.0.1#5353";
      DNSSEC = "true";
      WEBTHEME = "default-dark";
      INTERFACE = "bond0";
    };
    extraOptions = [
      "--network=host"
    ];
  };

  systemd.services."podman-pihole".postStart = '''';

  systemd.services."podman-pihole".preStart = ''
    mkdir -p /etc/pihole
    mkdir -p /etc/dnsmasq.d
  '';
}
