{ self, inputs, lib, ... }:
let
  inherit (builtins) length listToAttrs map readDir;
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (lib.attrsets) mapAttrsToList nameValuePair;
  inherit (lib.lists) foldr;
  inherit (lib.strings) hasSuffix removeSuffix;
  inherit (self) nixpkgs;
in
{
  flake.lib = lib // rec {
    nixpkgsConfig = { overlays ? [ ], config ? { } }: {
      nixpkgs = {
        config = {
          allowUnfree = true;
        } // config;
        overlays = overlays ++ (self.lib.attrsets.mapAttrsToList (_: v: v) self.overlays) ++ [
          inputs.nix-vscode-extensions.overlays.default
          inputs.nur.overlays.default
          inputs.nixgl.overlay
        ];
      };
    };

    mkUser = { name, extraGroups ? [ ], sshKeys ? [ ], ... }: {
      inherit name;
      value = {
        isNormalUser = true;
        createHome = true;
        group = "${name}";
        openssh.authorizedKeys.keys = sshKeys;
        inherit extraGroups;
      };
    };

    mkUserGroup = config: { name, ... }: {
      inherit name;
      value = {
        gid = config.users.users."${name}".uid;
      };
    };

    mkUsers = users: { config, ... }: {
      users = {
        users = listToAttrs (map mkUser users);
        groups = listToAttrs (map (mkUserGroup config) users);
      };
    };

    mkHMUser =
      { name
      , homeModules ? [ ]
      , userModule ? self.users."${name}"
      , extraArgs ? { }
      , ...
      }:
      {
        inherit name;
        value = {
          imports = [
            inputs.catppuccin.homeManagerModules.catppuccin
            (userModule extraArgs)
          ] ++ homeModules;
        };
      };

    mkHMUsers = users: listToAttrs (map mkHMUser users);

    mkHost =
      { hostName
      , system ? "x86_64-linux"
      , users ? [ ]
      , nixosModules ? [ ]
      }:
      nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs system nixpkgs;
          inherit (inputs) home-manager nur;
        };

        modules = nixosModules ++ [
          (nixpkgsConfig { })
          (self.hosts."${hostName}")
          (mkUsers users)
          inputs.home-manager.nixosModules.home-manager
          inputs.catppuccin.nixosModules.catppuccin
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = { inherit inputs nixpkgs self; };
              users = mkHMUsers users;
            };
          }
        ];
      };

    mkHome =
      { username
      , system ? "x86_64-linux"
      , homeModules ? [ ]
      , userModule ? self.users."${username}"
      , extraArgs ? { }
      }:
      let
        homeDirectory = "/home/${username}";
      in
      inputs.home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs nixpkgs system username self; };
        modules = [
          (nixpkgsConfig { })
          inputs.catppuccin.homeManagerModules.catppuccin
          {
            home = {
              inherit username homeDirectory;
              stateVersion = "22.11";
            };
          }
          (userModule extraArgs)
        ] ++ homeModules;
      };

    capitalise = str:
      let
        cs = (lib.stringToCharacters str);
        hd = if length cs > 0 then lib.head cs else "";
        tl = lib.tail cs;
      in
      lib.strings.concatStrings (prepend (lib.strings.toUpper hd) tl);

    # https://github.com/ners/NixOS/blob/master/profiles/lib/
    attrsToList = mapAttrsToList nameValuePair;

    prepend = x: xs: [ x ] ++ xs;
    append = x: xs: xs ++ [ x ];

    findModules = dir:
      let
        dirFiles = attrsToList (readDir dir);
        modules = ((foldr ({ name, value }: acc:
          let
            fullPath = dir + "/${name}";
            isNixModule = value == "regular" && hasSuffix ".nix" name && name != "default.nix";
            isDir = value == "directory";
            isDirModule = isDir && readDir fullPath ? "default.nix";
            module = nameValuePair (removeSuffix ".nix" name) (
              if isNixModule || isDirModule then fullPath
              else if isDir then findModules fullPath
              else { }
            );
          in
          if module.value == { } then acc
          else append module acc
        )) [ ]) dirFiles;
      in
      listToAttrs modules;

    optionalNotNull = module: lib.lists.optional (module != null) module;
    optionalsNotNull = modules: builtins.filter (m: m != null) modules;
  };
}

