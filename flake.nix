{
  description = "Henrik's Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    hermes-agent.url = "github:NousResearch/hermes-agent";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bzmenu.url = "github:e-tho/bzmenu";
    iwmenu.url = "github:e-tho/iwmenu";
    pwmenu.url = "github:e-tho/pwmenu";

    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor?ref=25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    unstable,
    nix-flatpak,
    hermes-agent,
    home-manager,
    bzmenu,
    iwmenu,
    pwmenu,
    nixos-06cb-009a-fingerprint-sensor,
    winapps,
    ...
  }:
    let
      systemSettings = {
        system = "x86_64-linux";
        hostname = "workpc";
      };

      userSettings = rec {
        username = "sn0w";
        gid = 100;
        uid = 1026;
        timezone = "Europe/Berlin";
        locale = "en_US.UTF-8";
        keyboard_layout = "de";
        homedir = "/home/${username}";
        musicdir = "/mnt/media/Music";
      };

      unstablePkgs = import unstable {
        system = systemSettings.system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        ${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
          system = systemSettings.system;

          modules = [
            hermes-agent.nixosModules.default
            ./configuration.nix
            ./modules/apps.nix
            ./modules/services.nix
            ./modules/filesystem.nix
            ./modules/firewall.nix
            ./modules/misc.nix

            ({ ... }: {
              home-manager.extraSpecialArgs = {
                inherit unstablePkgs inputs userSettings;
              };
            })

            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"

            ({ pkgs, ... }: {
              environment.systemPackages = [
                winapps.packages.${pkgs.system}.winapps
                winapps.packages.${pkgs.system}.winapps-launcher
              ];
            })
          ];

          specialArgs = {
            inherit inputs systemSettings userSettings unstablePkgs;
          };
        };
      };
    };
}
