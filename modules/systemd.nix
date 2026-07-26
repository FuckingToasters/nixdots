{ config, pkgs, userSettings, ... }:

{
  systemd.services = {
    "open-fprintd-resume".enable = true;
    "open-fprintd-suspend".enable = true;
    "hermes-agent".enable = true;
    "python3-validity".enable = true;
  };
}
