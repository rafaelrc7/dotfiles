{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (builtins) length listToAttrs readDir;
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (inputs.home-manager.lib) homeManagerConfiguration;
  inherit (inputs) nixpkgs;
  inherit (lib.attrsets) mapAttrs mapAttrsToList nameValuePair;
  inherit (lib.lists) foldr;
  inherit (lib.strings) hasSuffix removeSuffix;
in
{
  flake.lib = lib // rec {
    nixpkgsConfig =
      {
        overlays ? [ ],
        config ? { },
      }:
      {
        nixpkgs = {
          config = {
            allowUnfree = true;
          }
          // config;
          overlays = overlays ++ [
            inputs.nix-vscode-extensions.overlays.default
            inputs.nur.overlays.default
            inputs.nixgl.overlay
            inputs.hyprland.overlays.default
            (final: prev: {
              hyprtoolkit = inputs.hyprtoolkit.packages."${final.stdenv.hostPlatform.system}".hyprtoolkit;
            })
            self.overlays.default
          ];
        };
      };

    mkHomeConfiguration =
      {
        username,
        userModule ? self.users."${username}",
        gui ? true,
        profiles ? null,
        extraModules ? [ ],
        system ? "x86_64-linux",
        pkgs ? nixpkgs.legacyPackages.${system},
      }:
      homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs self; };
        modules = [
          (userModule {
            inherit (self) homeModules homeProfiles;
            inherit gui profiles extraModules;
          })
          (nixpkgsConfig { })
          inputs.catppuccin.homeModules.catppuccin
          inputs.hyprland.homeManagerModules.default
          {
            programs.home-manager.enable = true;
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
              stateVersion = "22.11";
            };
          }
        ];
      };

    mkNixosConfiguration =
      {
        system ? "x86_64-linux",
        users ? { },
        configuration,
      }:
      nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit (self) nixosModules nixosProfiles;
          inherit (inputs) home-manager nur nixos-hardware;
        };
        modules = [
          (import configuration)
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-ld.nixosModules.nix-ld
          inputs.catppuccin.nixosModules.catppuccin
          inputs.hyprland.nixosModules.default

          (nixpkgsConfig { })

          (mkUsers users)
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

    mkUsers =
      users:
      { config, ... }:
      {
        users = {
          users = mapAttrs mkUser users;
          groups = mapAttrs (mkUserGroup config) users;
        };
      };

    mkUser =
      name:
      {
        extraGroups ? [ ],
        sshKeys ? [ ],
        ...
      }:
      {
        isNormalUser = true;
        createHome = true;
        group = "${name}";
        openssh.authorizedKeys.keys = sshKeys;
        inherit extraGroups;
      };

    mkUserGroup = config: name: _: {
      gid = config.users.users."${name}".uid;
    };

    mkHMUsers = users: (mapAttrs mkHMUser users);

    mkHMUser =
      name:
      {
        userModule ? self.users."${name}",
        gui ? true,
        profiles ? null,
        extraModules ? [ ],
        ...
      }:
      {
        imports = [
          inputs.catppuccin.homeModules.catppuccin
          inputs.hyprland.homeManagerModules.default
          (userModule {
            inherit (self) homeModules homeProfiles;
            inherit gui profiles extraModules;
          })
        ];
      };

    capitalise =
      str:
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

    findModules =
      dir:
      let
        dirFiles = attrsToList (readDir dir);
        modules =
          (
            (foldr (
              { name, value }:
              acc:
              let
                fullPath = dir + "/${name}";
                isNixModule = value == "regular" && hasSuffix ".nix" name && name != "default.nix";
                isDir = value == "directory";
                isDirModule = isDir && readDir fullPath ? "default.nix";
                module = nameValuePair (removeSuffix ".nix" name) (
                  if isNixModule || isDirModule then
                    fullPath
                  else if isDir then
                    findModules fullPath
                  else
                    { }
                );
              in
              if module.value == { } then acc else append module acc
            ))
            [ ]
          )
            dirFiles;
      in
      listToAttrs modules;

    optionalNotNull = module: lib.lists.optional (module != null) module;
    optionalsNotNull = modules: builtins.filter (m: m != null) modules;
  };
}
