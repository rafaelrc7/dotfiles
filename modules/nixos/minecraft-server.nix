{
  lib,
  pkgs,
  config,
  ...
}:
let
  folderName = "minecraft";
  dataDir = "/srv/${folderName}";
  runDir = "/run/${folderName}";
  runServerJar = pkgs.writeShellScript "minecraft-server-run-jar" ''
    if [ -z "$1" ]; then
        echo "Server JAR was not supplied"
        exit 1
    fi
    ${lib.optionalString pkgs.stdenvNoCC.hostPlatform.isLinux "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${
      lib.makeLibraryPath [ pkgs.udev ]
    }"}
    exec ${lib.getExe pkgs.jre} -server ''${@:2} -jar ''$1 nogui
  '';
  stopScript = pkgs.writeShellScript "minecraft-server-stop" ''
    if [ -z "$1" ]; then
        echo "Server name was not supplied"
        exit 1
    fi
    echo stop > "${runDir}/$1.stdin"
  '';
in
{
  # Minecraft default port
  networking.firewall.allowedTCPPorts = [ 25565 ];

  # User/Group
  users.users.minecraft = {
    description = "Minecraft server service user";
    home = dataDir;
    createHome = true;
    isSystemUser = true;
    group = config.users.groups.minecraft.name;
    shell = "${pkgs.shadow}/bin/nologin";
  };

  users.groups.minecraft = {
    gid = config.users.users.minecraft.uid;
  };

  # Specific instances overrides
  systemd.services = {
    "minecraft-server@vanilla" = {
      overrideStrategy = "asDropin";
      serviceConfig.ExecStart = [
        ""
        ''${lib.getExe pkgs.papermc} -server -Xms''${MEM} -Xmx''${MEM} $JVM_OPTS''
      ];
    };
    "minecraft-server@test" = {
      overrideStrategy = "asDropin";
      serviceConfig.ExecStart = [
        ""
        ''${lib.getExe pkgs.papermc} -server -Xms''${MEM} -Xmx''${MEM} $JVM_OPTS''
      ];
    };
  };

  systemd.timers = {
    "minecraft-server-backup@vanilla" = {
      overrideStrategy = "asDropin";
      wantedBy = [ "timers.target" ];
    };
  };

  # Base minecraft server service
  # Based on: https://github.com/jtait/minecraft_systemd/ and the nixpkgs minecraft-server module
  systemd.services = {
    "minecraft-server@" = {
      unitConfig = {
        Description = "Minecraft Server - %i";
        Requires = "minecraft-server@%i.socket";
        After = [
          "network.target"
          "minecraft-server@%i.socket"
        ];
        ConditionPathExists = "${dataDir}/%i";
      };

      serviceConfig = {
        ExecStart = ''${runServerJar} ''${JAR_NAME} -Xms''${MEM} -Xmx''${MEM} $JVM_OPTS'';
        ExecStop = ''${stopScript} "%i"'';
        Restart = "on-failure";
        RestartSec = "60s";

        WorkingDirectory = "${dataDir}/%i";

        User = config.users.users.minecraft.name;
        Group = config.users.users.minecraft.group;

        Sockets = "minecraft-server@%i.socket";
        StandardInput = "socket";
        StandardOutput = "journal";
        StandardError = "journal";

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        PrivateDevices = true;
        LockPersonality = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
        ProtectSystem = "strict";
        ReadWritePaths = [
          runDir
          dataDir
        ];
        NoNewPrivileges = true;
        RemoveIPC = true;

        # Set default variables
        Environment = [
          "JAR_NAME=server.jar"
          "MEM=6144M"
          ''"JVM_OPTS=-Djava.net.preferIPv6Addresses=true -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1HeapRegionSize=8M -XX:G1HeapWastePercent=5 -XX:G1MaxNewSizePercent=40 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1NewSizePercent=30 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15 -XX:MaxGCPauseMillis=200 -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"''
        ];

        # Override default variable values in environment file
        EnvironmentFile = "-${dataDir}/%i/.env";

        # this is necessary to keep systemd from killing the process before it exits after ExecStop is called
        KillSignal = "SIGCONT";
      };
    };

    "minecraft-server-backup@" = {
      unitConfig = {
        Description = "Minecraft Server Backup Task - %i";
        ConditionDirectoryNotEmpty = "${dataDir}/%i";
        PartOf = "minecraft-server@%i.service";
      };

      serviceConfig = {
        Type = "oneshot";

        ExecStartPre = ''${pkgs.writeShellScript "minecraft-server-backup-pre" ''
          if [ $# -ne 2 ]; then
              echo "Must supply server name and backup path"
              exit 1
          fi

          SERVER_NAME=$1
          BACKUP_PATH=$2
          SOCKET="${runDir}/$SERVER_NAME.stdin"

          ${pkgs.coreutils}/bin/mkdir -p ''${BACKUP_PATH}

          if [ -p "$SOCKET" ]; then
            echo "say Running backup..." > "$SOCKET"
            echo "save-off" > "$SOCKET"
            sleep 2
            echo "save-all" > "$SOCKET"
            stdbuf -oL tail -n2 -f "${dataDir}/$SERVER_NAME/logs/latest.log" \
              | sed '/Saved the game/q'
          fi
        ''} %i ''${BACKUP_PATH}'';

        ExecStart = ''${
          lib.getExe (
            pkgs.writeShellApplication {
              name = "minecraft-server-backup";
              runtimeInputs = with pkgs; [
                gnutar
                xz
              ];
              text = ''
                if [ $# -ne 2 ]; then
                    echo "Must supply server name and backup path"
                    exit 1
                fi

                SERVER_NAME=$1
                BACKUP_PATH=$2
                DATE=$(date +"%F_%H-%M-%S")

                tar --exclude=backup --exclude=cache --exclude=libraries \
                  --exclude=logs --exclude=versions --exclude=crash-reports \
                  --exclude=.env \
                  -cJf "$BACKUP_PATH/$SERVER_NAME-$DATE".tar.xz \
                  -C "${dataDir}" "$SERVER_NAME"
              '';
            }
          )
        } %i ''${BACKUP_PATH}'';

        ExecStopPost = ''${pkgs.writeShellScript "minecraft-server-backup-post" ''
          if [ $# -ne 2 ]; then
              echo "Must supply server name and backup path"
              exit 1
          fi

          SERVER_NAME=$1
          BACKUP_PATH=$2
          SOCKET="${runDir}/$SERVER_NAME.stdin"

          if [ -p "$SOCKET" ]; then
            echo "save-on" > "$SOCKET"
            echo "say Backup complete." > "$SOCKET"
          fi
        ''} %i ''${BACKUP_PATH}'';

        WorkingDirectory = "${dataDir}/%i";

        User = config.users.users.minecraft.name;
        Group = config.users.users.minecraft.group;

        StandardOutput = "journal";
        StandardError = "journal";

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        PrivateDevices = true;
        LockPersonality = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        PrivateNetwork = true;
        RestrictAddressFamilies = "none";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
        ProtectSystem = "strict";
        ReadWritePaths = [ dataDir ];
        NoNewPrivileges = true;
        RemoveIPC = true;

        # Set default variables
        Environment = [
          "BACKUP_PATH=${dataDir}/%i/backup"
        ];

        # Override default variable values in environment file
        EnvironmentFile = "-${dataDir}/%i/.env";
      };
    };
  };

  systemd.sockets."minecraft-server@" = {
    unitConfig = {
      BindsTo = "minecraft-server@%i.service";
    };

    socketConfig = {
      Service = "minecraft-server@%i.service";
      ListenFIFO = "${runDir}/%i.stdin";
      SocketMode = "0600";
      SocketUser = config.users.users.minecraft.name;
      SocketGroup = config.users.users.minecraft.group;
      RemoveOnStop = true;
      FlushPending = true;
    };
  };

  systemd.timers."minecraft-server-backup@" = {
    unitConfig = {
      Description = "Minecraft Server Backup Task Schedule - %i";
    };
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      Unit = "minecraft-server-backup@%i.service";
    };
  };
}
