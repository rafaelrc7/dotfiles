{
  description = "My NixOS configurations and dotfiles flake";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nix-colors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/nur";
    awesomerc.url = "github:rafaelrc7/awesomerc";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      flake = false;
      url = "github:rafaelrc7/nvimrc";
    };

    awesome-git = {
      flake = false;
      url = "github:awesomewm/awesome";
    };

  };

  outputs = inputs@{ nixpkgs, home-manager, nixos-hardware, nixgl, ... }:
  let
    utils = import ./utils inputs;
  in {
    nixosConfigurations = {
      "vulcan" = utils.mkHost {
        hostName = "vulcan";
        system = "x86_64-linux";
        users = [
          { name = "rafael";
            extraGroups = [ "wheel" "adbusers" "libvirtd" "dialout" ];
            sshKeys = import ./users/rafael/sshkeys.nix;
            homeModules = [
              inputs.awesomerc.setup
              ./users/rafael/crypto.nix
              ./users/rafael/git.nix
              ./users/rafael/go.nix
              ./users/rafael/gui-pkgs.nix
              ./users/rafael/gui-theme.nix
              ./users/rafael/gschemas.nix
              ./users/rafael/jetbrains.nix
              ./users/rafael/kitty.nix
              ./users/rafael/mpd.nix
              ./users/rafael/neovim.nix
              ./users/rafael/pass.nix
              ./users/rafael/rclone-gdrive.nix
              ./users/rafael/sway.nix
              ./users/rafael/waybar.nix
              ./users/rafael/xdg.nix
              ./users/rafael/zsh.nix
            ];
          }
        ];
        nixosModules = [
          ./modules/nixos/common.nix
          ./modules/nixos/android.nix
          ./modules/nixos/awesomewm.nix
          ./modules/nixos/boot.nix
          ./modules/nixos/btrfs.nix
          ./modules/nixos/flatpak.nix
          ./modules/nixos/geoclue.nix
          ./modules/nixos/libvirtd.nix
          #./modules/nixos/mullvad.nix
          ./modules/nixos/nix.nix
          ./modules/nixos/pipewire.nix
          #./modules/nixos/plasma.nix
          #./modules/nixos/steam.nix
          ./modules/nixos/zsh.nix
          ./modules/nixos/podman.nix
          ./modules/nixos/fonts.nix
          ./modules/nixos/cryptswap.nix
          ./modules/nixos/man.nix
          ./modules/nixos/ssh.nix
          ./modules/nixos/git.nix
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
        ];
      };

      "spitfire" = utils.mkHost {
        hostName = "spitfire";
        system = "x86_64-linux";
        users = [
          { name = "rafael";
            extraGroups = [ "wheel" "adbusers" "dialout" ];
            sshKeys = import ./users/rafael/sshkeys.nix;
            homeModules = [
              inputs.awesomerc.setup
              ./users/rafael/git.nix
              ./users/rafael/go.nix
              ./users/rafael/gui-pkgs.nix
              ./users/rafael/gui-theme.nix
              ./users/rafael/gschemas.nix
              ./users/rafael/jetbrains.nix
              ./users/rafael/kitty.nix
              ./users/rafael/mpd.nix
              ./users/rafael/neovim.nix
              ./users/rafael/pass.nix
              ./users/rafael/rclone-gdrive.nix
              ./users/rafael/sway.nix
              ./users/rafael/waybar.nix
              ./users/rafael/xdg.nix
              ./users/rafael/zsh.nix
            ];
          }
        ];
        nixosModules = [
          ./modules/nixos/common.nix
          ./modules/nixos/android.nix
          ./modules/nixos/awesomewm.nix
          ./modules/nixos/boot.nix
          ./modules/nixos/btrfs.nix
          #./modules/nixos/dnscrypt.nix
          ./modules/nixos/flatpak.nix
          ./modules/nixos/geoclue.nix
          ./modules/nixos/nix.nix
          ./modules/nixos/pipewire.nix
          ./modules/nixos/plasma.nix
          ./modules/nixos/zsh.nix
          ./modules/nixos/fonts.nix
          ./modules/nixos/cryptswap.nix
          ./modules/nixos/man.nix
          #./modules/nixos/mullvad.nix
          ./modules/nixos/ssh.nix
          ./modules/nixos/git.nix
          ./modules/nixos/udev-media-keys.nix
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-laptop
        ];
      };

      "harrier" = utils.mkHost {
        hostName = "harrier";
        system = "aarch64-linux";
        users = [
          { name = "rafael";
            extraGroups = [ "wheel" ];
            sshKeys = import ./users/rafael/sshkeys.nix;
            homeModules = [
              ./users/rafael/git.nix
              ./users/rafael/neovim-nolsp.nix
              ./users/rafael/pass.nix
              ./users/rafael/zsh.nix
            ];
          }
        ];
        nixosModules = [
          ./modules/nixos/common.nix
          ./modules/nixos/dnscrypt.nix
          ./modules/nixos/geoclue.nix
          ./modules/nixos/nix.nix
          ./modules/nixos/pihole.nix
          ./modules/nixos/zsh.nix
          ./modules/nixos/fonts.nix
        ];
      };
    };

    homeConfigurations = {
      "rafael" = utils.mkHome {
        system = "x86_64-linux";
        username = "rafael";
        homeModules = [
          inputs.awesomerc.setup
          ./users/rafael/git.nix
          ./users/rafael/go.nix
          ./users/rafael/gui-pkgs.nix
          ./users/rafael/gui-theme.nix
          ./users/rafael/jetbrains.nix
          ./users/rafael/kitty.nix
          ./users/rafael/mpd.nix
          ./users/rafael/neovim.nix
          ./users/rafael/pass.nix
          ./users/rafael/xdg.nix
          ./users/rafael/zsh.nix
          ({ pkgs, ... }: {
            programs.kitty.package = pkgs.writeShellScriptBin "kitty" ''
              ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.kitty}/bin/kitty "$@"
            '';
            programs.mpv.package = pkgs.writeShellScriptBin "mpv" ''
              ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.mpv}/bin/mpv "$@"
            '';
          })
        ];
        overlays = [
          (final: prev: {
            tdesktop = (final.writeShellScriptBin "telegram-desktop" ''
              ${final.nixgl.auto.nixGLDefault}/bin/nixGL ${prev.tdesktop}/bin/telegram-desktop "$@"
            '');
          })
        ];
      };

      "work" = utils.mkHome {
        system = "x86_64-linux";
        username = "rafael";
        homeModules = [
          ./users/rafael/git-work.nix
          ./users/rafael/neovim-nolsp.nix
          ./users/rafael/pass.nix
          ./users/rafael/zsh.nix
        ];
      };
    };
  };
}

