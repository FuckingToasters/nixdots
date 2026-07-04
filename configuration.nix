{ config, pkgs, inputs, systemSettings, userSettings, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    #useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs systemSettings userSettings; };
    users.${userSettings.username} = {
      imports = [ ./home.nix ];
    };
  };

  # Ensure the "users" group has the same GID as on the NAS
  users.groups.users = {
    gid = userSettings.gid;
  };

  # Define the main user with the same UID/GID as NAS user "sn0w"
  users.users.${userSettings.username} = {
    isNormalUser = true;
    uid = userSettings.uid;
    group = "users";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "input"
    ];
    home = userSettings.homedir;
    createHome = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.firmware = [ pkgs.linux-firmware ];
  hardware.firmwareCompression = "none";
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  networking.hostName = "${systemSettings.hostname}"; # Define your hostname.
  #networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;

  time.timeZone = "${userSettings.timezone}";
  i18n.defaultLocale = "${userSettings.locale}";
  #users.groups.libvirtd.members = ["${userSettings.username}"];

  services.xserver.xkb = {
    layout = "${userSettings.keyboard_layout}";
  };

  nix.settings.experimental-features =[ "flakes" "nix-command" ];

  environment.variables.KITTY_CONFIG_DIRECTORY = "~/.config/kitty";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
