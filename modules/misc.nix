{ config, pkgs, inputs, ... }:

{
  # Your existing menu packages
  environment.systemPackages = [
    inputs.bzmenu.packages.${pkgs.system}.default
    inputs.iwmenu.packages.${pkgs.system}.default
    inputs.pwmenu.packages.${pkgs.system}.default
  ];

  # New NixOS 25.05 graphics options (replaces hardware.opengl.*)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Steam and gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  hardware.steam-hardware.enable = true;

  # New Pulseaudio option name (replaces hardware.pulseaudio.support32Bit)
  # services.pulseaudio.support32Bit =
  #   (config.services.pulseaudio.enable or true);

  # Hybrid Intel + Nvidia (PRIME offload)
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Bus IDs for your GPUs (from lspci)
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
  };
}
