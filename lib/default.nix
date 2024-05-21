{ self, inputs, lib, ... }: with lib; with builtins; with inputs.nixpkgs.lib; {
  flake.lib = lib // rec {

    mkPkgs = { nixpkgs ? inputs.nixpkgs, system ? "x86_64-linux", overlays ? [ ], config ? { } }:
      import nixpkgs {
        inherit system overlays;

        config = {
          allowUnfree = true;
        } // config;
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

    mkUsers = with builtins; users: { config, ... }: {
      users = {
        users = listToAttrs (map mkUser users);
        groups = listToAttrs (map (mkUserGroup config) users);
      };
    };

    mkHMUser = with builtins; { name
                              , homeModules ? [ ]
                              , userModule ? self.users."${name}"
                              , extraArgs ? { }
                              , ...
                              }:
      {
        inherit name;
        value = {
          imports = [ (userModule extraArgs) ] ++ homeModules;
        };
      };

    mkHMUsers = with builtins; users: listToAttrs (map mkHMUser users);

    mkHost =
      { hostName
      , system ? "x86_64-linux"
      , users ? [ ]
      , nixosModules ? [ ]
      , pkgs ? (mkPkgs { inherit (inputs) nixpkgs; inherit system; })
      }:
      nixosSystem {
        inherit system;

        specialArgs = {
          inherit pkgs inputs system nixpkgs;
          inherit (inputs) home-manager nur;
        };

        modules = nixosModules ++ [
          (self.hosts."${hostName}")
          (mkUsers users)
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs pkgs nixpkgs self; };
              users = mkHMUsers users;
            };
          }
        ];
      };

    mkHome =
      { username
      , system ? "x86_64-linux"
      , homeModules ? [ ]
      , pkgs ? (mkPkgs { inherit (inputs) nixpkgs; inherit system; })
      , userModule ? self.users."${username}"
      , extraArgs ? { }
      }:
      let
        homeDirectory = "/home/${username}";
      in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs pkgs nixpkgs system username self; };
        modules = [
          inputs.stylix.homeManagerModules.stylix
          {
            home = {
              inherit username homeDirectory;
              stateVersion = "22.11";
            };
          }
          (userModule extraArgs)
        ] ++ homeModules;
      };

    # https://github.com/ners/NixOS/blob/master/profiles/lib/
    attrsToList = attrsets.mapAttrsToList attrsets.nameValuePair;

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

