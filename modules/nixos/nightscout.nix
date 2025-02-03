{
  lib,
  config,
  pkgs,
  ...
}:
let
  nightscoutPath = "/var/cache/nightscout";
in
{
  boot.kernel.sysctl = {
    # TODO: CAP_NET_BIND_SERVICE
    "net.ipv4.ip_unprivileged_port_start" = 80;
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
  };

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  users.users.nightscout = {
    createHome = true;
    home = nightscoutPath;
    isNormalUser = true;
    group = config.users.users.nightscout.name;
    extraGroups = [ "podman" ];
    linger = true;
  };

  users.groups.nightscout = {
    gid = config.users.users.nightscout.uid;
  };

  home-manager.users.nightscout =
    let
      homeDir = config.users.users.nightscout.home;
      envFile = "${homeDir}/.env";
    in
    {
      home.stateVersion = "22.11";

      home.packages = with pkgs; [
        podman
        podman-compose
      ];

      systemd.user.services.nightscout =
        let
          execStartPre = pkgs.writeShellScriptBin "execStartPre" ''
            #!/usr/bin/env bash
            ${pkgs.coreutils}/bin/mkdir -p ${homeDir}/mongo-data
            ${pkgs.coreutils}/bin/mkdir -p ${homeDir}/letsencrypt
          '';
        in
        {
          Unit = {
            Description = "Nightscout CGM Remote Monitor";
            Documentation = [ "https://nightscout.github.io/" ];
            Wants = "network-online.target";
            After = "network-online.target";
            ConditionPathExists = envFile;
          };

          Service = {
            WorkingDirectory = homeDir;
            # TODO: Fix PATH
            Environment = "PATH=/bin:/sbin:/nix/var/nix/profiles/default/bin:/run/wrappers/bin:${
              lib.makeBinPath [
                pkgs.podman
                pkgs.podman-compose
              ]
            }:$PATH";
            EnvironmentFile = envFile;
            Restart = "always";
            RestartSec = "30";
            ExecStartPre = "${pkgs.bash}/bin/bash ${execStartPre}/bin/execStartPre";
            ExecStart = "${pkgs.podman}/bin/podman compose up";
            ExecStop = "${pkgs.podman}/bin/podman compose down";
            TimeoutStopSec = "20";
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };

      # Some variables are need to be set in $HOME/.env
      # NSURL = service url
      # NSEMAIL = emailse used for SSL certificate
      # NSAPIKEY = secret api key
      # NSPODMANSOCKET = path to rootless podman.sock (/run/user/$UID/podman/podman.sock)
      home.file."docker-compose.yml".text = ''
        version: '3'

        x-logging:
          &default-logging
          options:
            max-size: '10m'
            max-file: '5'
          driver: journald

        services:
          mongo:
            image: docker.io/mongo:4.4
            volumes:
              - ${homeDir}/mongo-data:/data/db:cached
            logging: *default-logging

          nightscout:
            image: docker.io/nightscout/cgm-remote-monitor:latest
            container_name: nightscout
            restart: always
            depends_on:
              - mongo
            labels:
              - 'traefik.enable=true'
              - 'traefik.http.routers.nightscout.rule=Host(`''${NSURL}`)'
              - 'traefik.http.routers.nightscout.entrypoints=websecure'
              - 'traefik.http.routers.nightscout.tls.certresolver=le'
            logging: *default-logging
            environment:
              ### Variables for the container
              NODE_ENV: production
              TZ: ${config.time.timeZone}

              ### Overridden variables for Docker Compose setup
              # The `nightscout` service can use HTTP, because we use `traefik` to serve the HTTPS
              # and manage TLS certificates
              INSECURE_USE_HTTP: 'true'

              # For all other settings, please refer to the Environment section of the README
              ### Required variables
              # MONGO_CONNECTION - The connection string for your Mongo database.
              # Something like mongodb://sally:sallypass@ds099999.mongolab.com:99999/nightscout
              # The default connects to the `mongo` included in this docker-compose file.
              # If you change it, you probably also want to comment out the entire `mongo` service block
              # and `depends_on` block above.
              MONGO_CONNECTION: mongodb://mongo:27017/nightscout

              # API_SECRET - A secret passphrase that must be at least 12 characters long.
              API_SECRET: ''${NSAPIKEY}

              ### Features
              # ENABLE - Used to enable optional features, expects a space delimited list, such as: careportal rawbg iob
              # See https://github.com/nightscout/cgm-remote-monitor#plugins for details
              ENABLE: careportal rawbg boluscalc food iob cob bwp basal

              # AUTH_DEFAULT_ROLES (readable) - possible values readable, denied, or any valid role name.
              # When readable, anyone can view Nightscout without a token. Setting it to denied will require
              # a token from every visit, using status-only will enable api-secret based login.
              AUTH_DEFAULT_ROLES: denied

              # For all other settings, please refer to the Environment section of the README
              # https://github.com/nightscout/cgm-remote-monitor#environment

              ### Settings
              DISPLAY_UNITS: mg/dl

              TIME_FORMAT: 24

              THEME: colors

          traefik:
            image: docker.io/traefik:latest
            container_name: 'traefik'
            command:
              - '--providers.docker=true'
              - '--providers.docker.exposedbydefault=false'
              - '--entrypoints.web.address=:80'
              - '--entrypoints.web.http.redirections.entrypoint.to=websecure'
              - '--entrypoints.websecure.address=:443'
              - "--certificatesresolvers.le.acme.httpchallenge=true"
              - "--certificatesresolvers.le.acme.httpchallenge.entrypoint=web"
              - '--certificatesresolvers.le.acme.storage=/letsencrypt/acme.json'
              # Change the below to match your email address
              - '--certificatesresolvers.le.acme.email=''${NSEMAIL}'
            ports:
              - '443:443'
              - '80:80'
            volumes:
              - '${homeDir}/letsencrypt:/letsencrypt'
              - ''${NSPODMANSOCKET}:/var/run/docker.sock:ro
            logging: *default-logging
      '';
    };
}
