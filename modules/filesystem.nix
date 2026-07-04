{ config, pkgs, ... }:

{
  # File System

  fileSystems."/smssd" = {
    device = "/dev/disk/by-uuid/3dbd2939-f90f-4551-aecb-c7d16217cab7";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  # NFS


  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /smssd *(rw,nohide,insecure,no_subtree_check,sync,all_squash,anonuid=1000,anongid=1000)
  '';

    fileSystems."/mnt/media" = {
      device = "100.114.145.128:/volume1/MediaDrive";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" "rw" "vers=4" ];
    };

    fileSystems."/mnt/bewerbung" = {
      device = "100.114.145.128:/volume1/Bewerbung";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" "rw" "vers=4" ];
    };

    #fileSystems."/mnt/hub" = {
      #device = "192.168.86.202:/mnt/hub";
      #fsType = "nfs";
      #options = [ "x-systemd.automount" "noauto" "rw" "vers=4" ];
    #};

    #fileSystems."/mnt/backups" = {
      #device = "192.168.86.202:/backups";
      #fsType = "nfs";
      #options = [ "x-systemd.automount" "noauto" "rw" "vers=4" ];
    #};

  # Bind user Hermes skills into system Hermes home so the gateway/se see them
  fileSystems."/var/lib/hermes/.hermes/skills" = {
    device = "/home/henrikp/.hermes/skills";
    fsType = "none";
    options = [ "bind" ];
  };

}
