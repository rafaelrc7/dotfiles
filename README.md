# My personal Nix Flake

<img
src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg"
align="right" alt="Nix logo" width="150">

> This is my Nix flake. There are many like it, but this one is mine.
>
> My Nix flake is my best friend. It is my life. I must master it as I must
> master my life.
>
> Without me, my Nix flake is useless. Without my Nix flake, I am useless. I
> must configure my Nix flake true. I must build more reproducibly than my
> computer who is trying to deceive me. I must configure it before it deceives
> me. I will ...
>
> My Nix flake and I know that what counts in IT is not the amount of words we
> type, the noise of our keyboard, nor the outputs we make. We know that it is
> the derivations that count. We will derive ...
>
> My Nix flake is human, even as I am human, because it is my life. Thus, I
> will learn it as a brother. I will learn its weaknesses, its strength, its
> code, its tooling, its inputs and outputs. I will keep my Nix flake clean and
> ready, even as I am clean and ready. We will become part of each other. We
> will ...
>
> Before God, I swear this creed. My Nix flake and I are the defenders of
> reliability. We are the masters of reproducibility. We are the saviors of my
> life.
>
> So be it, until victory is reproducible and there is no uncertainty, but
> peace!
>
> — [NixOS User's Creed](https://github.com/ners/NixOS)

## Overview
This is the repository of my personal nix flake. It can be used to build
different NixOS systems or to setup a user configuration in non-nixos systems
trough home-manager.

## Goals
My main goal is to make a customisable config that can be easily adapted. For
instance, I always assume that a system can have multiple users that have
different settings. Users may be defined trough home-manager and be added to
both nixos and non-nixos systems with minimal hassle and a lot of liberty.

Systems may also be built using unique or shared modules at will.

## Installation

```sh
git clone https://github.com/rafaelrc7/dotfiles/
cd dotfiles
```

### Host configuration
If building for the first time.
```sh
nixos-rebuild --use-remote-sudo switch --flake .#hostname
```

If rebuilding a system, as it defaults to use the systems hostname.
```sh
nixos-rebuild --use-remote-sudo switch --flake .
```

### Home-Manager configuration
```sh
nix build --impure .#homeConfigurations.username.activationPackage && ./result/activate
```

## Structure

### flake.nix
Here all the buildable hosts and users are defined, using utility functions and
modules.

### Hosts
NixOS systems may be defined at the ```hosts/``` directory. Inside it, you may
create a folder for said host.

Inside ```hosts/hostname``` you may define a ```default.nix``` file with all
expected configurations for a nixos host and any other modules you choose.

### Home-Manager users
Home-Manager users may be defined at the ```users``` directory. Inside it, you
may create a folder for each user.

Inside ```users/username``` you may define a ```default.nix``` file with all
expected home-manager configuration.

### Modules
You may define shared NixOS modules at ```modules/nixos```.

### Utils
The ```Utils``` folders defines various utility functions used by me, mainly,
on the definition of the ```flake.nix file```.

#### mkHome
The ```mkHome``` function creates a flake for a home-manager configuration on a
non-nixos system.

It's parameters are:
- username
- system (defaults to "x86_64")
- homeModules (defaults to empty list)

	List of user nix modules that should be included.

- overlays (defaults to empty list)

	List of overlays to add to user packages.

- nixpkgs (defaults to ```inputs.nixpkgs```)

#### mkHost
The ```mkHost``` function creates a flake for a NixOS system configuration.

It's parameters are:
- hostName
- system (defaults to "x86_64")
- users (defaults to empty list)

	List of attrsets representing existing home-manager configurations that
	should be included on the host.

	The fields of the attrset are:

	- name
	- extraGroups (defaults to empty list)
	- sshKeys (defaults to empty list)

- nixosModules (defaults to empty list)

	List of modules to be added to system configuration.

- nixpkgs (defaults to ```inputs.nixpkgs```)

