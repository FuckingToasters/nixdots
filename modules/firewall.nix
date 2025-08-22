{ config, pkgs, ... }:

{
   networking.firewall = {
     # For complex routing (i.e Synology over Tailscale)
     #checkReversePath = "loose";
     trustedInterfaces = [ "tailscale0" ];
     # Allow NFS & localsend traffic through the firewall     
     allowedTCPPorts = [ 2049 111 53317 ];
     allowedUDPPorts = [ 2049 111 53317 ];
     allowedTCPPortRanges = [
       { from = 32765; to = 32769; }
     ];
     allowedUDPPortRanges = [
       { from = 32765; to = 32769; }
     ];

   };
}
