{ config, pkgs, userSettings, ... }:

{
  services.connman = {
    enable = true;
    wifi.backend = "iwd";
  };

  services.connman.extraConfig = ''
    BackgroundScanning = true
    AllowHostnameUpdates = false
    EnableOnlineCheck = false
  '';

  services.fwupd.enable = true;
  services.blueman.enable = true;
  services.printing.enable = true;
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
    useRoutingFeatures = "client";
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
    };
  };

  services.sunshine = {
    enable = false;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  services.resolved = {
    enable = true;

    # All the knobs go under `settings` in current NixOS
    settings = {
      DNS = [ "1.1.1.1" "8.8.8.8" ];
      FallbackDNS = [ "9.9.9.9" ];
      # Optional, but can be nice:
      MulticastDNS = "resolve";
      # LLMNR = "no";
    };
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.envfs.enable = true;

  services.openssh.enable = true;
  services.flatpak.enable = true;
  services.mullvad-vpn.enable = true;
  services.i2p.enable = true;

  services.hermes-agent = {
    enable = true;
    settings.model.default = "anthropic/claude-sonnet-4";
    environmentFiles = [ "/etc/hermes/hermes-env" ];
    addToSystemPackages = true;
  };
  
  #services.i2pd = {
    #enable = true;
    #port = 30777;
    #ntcp2.port = 30776;

    #proto = {
      #httpProxy.enable = true;
      #socksProxy.enable = true;

      #http = {
        #enable = true;
        #address = "127.0.0.1";
        #hostname = "localhost";
        #port = 7070;
      #};
    #};
  #};

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      log-driver = "journald";
      storage-driver = "overlay2";
    };
  };
  virtualisation.podman = {
    enable = false;
    dockerCompat = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
}
