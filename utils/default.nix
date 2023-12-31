inputs: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
in rec {

  mkPkgs = { nixpkgs ? inputs.nixpkgs, overlays ? [], system }:
    import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-25.9.0" ];
      };

      overlays = overlays ++ [
        inputs.nur.overlay
        #(import ../overlay { inherit inputs sytem; })
        inputs.nix-vscode-extensions.overlays.default
        inputs.nixgl.overlay
        (final: prev: {
          nixpkgs-stable = inputs.nixpkgs-stable.legacyPackages."${system}";
          nixpkgs-unstable = inputs.nixpkgs-unstable.legacyPackages."${system}";
          nixpkgs-master = inputs.nixpkgs-master.legacyPackages."${system}";
          wayland-pipewire-idle-inhibit = inputs.wayland-pipewire-idle-inhibit.defaultPackage."${system}";
        })
      ];
    };

  mkUser = { name, extraGroups ? [], sshKeys ? [], ... }: {
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

  mkHMUser = with builtins; { name, homeModules ? [], ... }: {
    inherit name;
    value = { imports = [(../users + "/${name}")] ++ homeModules; };
  };

  mkHMUsers = with builtins; users: listToAttrs (map mkHMUser users);

  mkHost = { hostName,
             system ? "x86_64-linux",
             users ? [],
             nixosModules ? [],
             nixpkgs ? inputs.nixpkgs }:
  let
    pkgs = mkPkgs { inherit nixpkgs system; };
  in nixosSystem {
    inherit system;

    specialArgs = {
      inherit pkgs inputs system nixpkgs;
      inherit (inputs) home-manager nur;
    };

    modules = nixosModules ++ [
      (../hosts + "/${hostName}")
      (mkUsers users)
      inputs.home-manager.nixosModules.home-manager {
        home-manager = {
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs pkgs nixpkgs; };
          users = mkHMUsers users;
        };
      }
    ];
  };

  mkHome = { username,
             system ? "x86_64-linux",
             homeModules ? [],
             overlays ? [],
             nixpkgs ? inputs.nixpkgs }:
  let
    pkgs = mkPkgs { inherit nixpkgs system overlays; };
    homeDirectory = "/home/${username}";
  in inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs pkgs nixpkgs system username; };
    modules = [
      {
        home = {
          inherit username homeDirectory;
          stateVersion = "22.11";
        };
      }
      (../users + "/${username}")
    ] ++ homeModules;
  };
}

