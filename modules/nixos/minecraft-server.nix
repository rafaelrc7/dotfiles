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
  java = pkgs.jre;
  runServer = pkgs.writeShellScript "runServer" ''
    if [ -z "$1" ]; then
        echo "Server JAR was not supplied"
        exit 1
    fi
    ${lib.optionalString pkgs.stdenvNoCC.hostPlatform.isLinux "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${
      lib.makeLibraryPath [ pkgs.udev ]
    }"}
    export MEM="''${MEM:-6144M}"
    ${lib.getExe java} -server -Xms''${MEM} -Xmx''${MEM} ''${@:2} -jar ''$1 nogui
  '';
in
{
  networking.firewall.allowedTCPPorts = [ 25565 ];

  users.users.minecraft = {
    isSystemUser = true;
    home = dataDir;
    createHome = true;
    group = config.users.groups.minecraft.name;
    shell = "${pkgs.shadow}/bin/nologin";
  };

  users.groups.minecraft = {
    gid = config.users.users.minecraft.uid;
  };

  # Based on: https://github.com/jtait/minecraft_systemd/
  systemd.services = {
    "minecraft-server@" = {
      unitConfig = {
        Description = "Minecraft Server - %i";
        After = "network.target";
        ConditionPathExists = "${dataDir}/%i";
      };

      serviceConfig = {
        WorkingDirectory = "${dataDir}/%i";

        User = config.users.users.minecraft.name;
        Group = config.users.users.minecraft.group;

        Sockets = "minecraft-server@%i.socket";
        StandardInput = "socket";
        StandardOutput = "journal";
        StandardError = "journal";

        PrivateUsers = true;
        ProtectSystem = "full";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;

        # Set default variables
        Environment = [
          "MEM=6144M"
          ''"JAVA_PARAMETERS=-Djava.net.preferIPv6Addresses=true -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1HeapRegionSize=8M -XX:G1HeapWastePercent=5 -XX:G1MaxNewSizePercent=40 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1NewSizePercent=30 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15 -XX:MaxGCPauseMillis=200 -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"''
          "JAR_PATH=server.jar"
        ];

        # Override default variable values in environment file
        EnvironmentFile = "-${dataDir}/%i/.env";

        ExecStart = ''/bin/sh -c "${runServer} ''${JAR_PATH} ''${JAVA_PARAMETERS}"'';
        ExecStop = ''/bin/sh -c "echo stop > ${runDir}/%i.stdin"'';
        Restart = "on-failure";
        RestartSec = "60s";

        # this is necessary to keep systemd from killing the process before it exits after ExecStop is called
        KillSignal = "SIGCONT";
      };
    };
  };

  systemd.sockets = {
    "minecraft-server@" = {
      unitConfig = {
        BindsTo = "minecraft-server@%i.service";
      };

      socketConfig = {
        ListenFIFO = "${runDir}/%i.stdin";
        Service = "minecraft-server@%i.service";
        SocketUser = config.users.users.minecraft.name;
        SocketGroup = config.users.users.minecraft.group;
        RemoveOnStop = true;
        SocketMode = "0600";
      };
    };
  };
}
