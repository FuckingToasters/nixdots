{
  description = "Henrik's Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
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
  };
  outputs = inputs@{
    self,
    nixpkgs,
    unstable,
    nix-flatpak,
    home-manager,
    nixos-06cb-009a-fingerprint-sensor,
    ...
  }:
    let
      systemSettings = {
        system = "x86_64-linux";
        hostname = "workpc";
      };
      userSettings = {
        username = "henrikp";
        timezone = "Europe/Berlin";
        locale = "en_US.UTF-8";
        keyboard_layout = "de";
	homedir = "/home/${userSettings.username}";
        musicdir = "/mnt/media/Music";
      };

      unstablePkgs = import unstable { system = systemSettings.system; };

    in {
      nixosConfigurations = {
        ${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            ./configuration.nix
            ./modules/apps.nix
            ./modules/services.nix
            ./modules/filesystem.nix
            ./modules/firewall.nix
            ./modules/misc.nix
            # ... your other modules ...
            ({ ... }: {
              # Pass specialArgs to home-manager!
              home-manager.extraSpecialArgs = {
                inherit unstablePkgs inputs userSettings;
              };
            })
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
          ];
          specialArgs = {
            inherit inputs systemSettings userSettings unstablePkgs;
          };
        };
      };
    };
}
