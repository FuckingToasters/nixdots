{ config, pkgs, userSettings, ... }:

{
  services.connman = {
    enable = true;
    wifi.backend = "iwd";
  };
  services.fwupd.enable = true;
  services.blueman.enable = true;  
  services.printing.enable = true;
  #services.pulseaudio.enable = false;
  services.acpid.enable = true;
  security.rtkit.enable = true;
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    gdm.fprintAuth = true;
  };
  services."06cb-009a-fingerprint-sensor" = {                                 
    enable = true;                                                            
    backend = "python-validity";                                              
  };
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client"; # client, server, both
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.mpd = {
    enable = true;
    user = "${userSettings.username}";
    musicDirectory = "${userSettings.musicdir}";
    extraConfig = ''
      audio_output {
        type "pulse"
        name "PulseAudio"
      }
    '';

    network = {
      #listenAddress = "any";     # optional, allows remote connections
      #startWhenNeeded = true;    # socket activation
    };

  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.envfs.enable = true;
  services.resolved.enable = true;

  services.openssh.enable = true;

  services.flatpak.enable = true; 
  services.xserver.enable = true;

  services.mullvad-vpn.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.podman = {
  enable = true;
  dockerCompat = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service

}

