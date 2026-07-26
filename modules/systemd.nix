{ config, pkgs, ... }:

{
  systemd.user.services = {
    autogitpush = {
      Unit = {
        Description = "Auto git commit/push repos to GitHub";
      };
      Service = {
        Type = "oneshot";
        WorkingDirectory = "/home/sn0w/dotfiles/workpc";
        ExecStart = "${pkgs.bash}/bin/bash -c 'for d in ${config.home.homeDirectory}/dotfiles/workpc ${config.home.homeDirectory}/.config; do if [ -d \"$d/.git\" ]; then cd \"$d\" && git add . && git commit -m auto && GIT_SSH_COMMAND=\"ssh -i ${config.home.homeDirectory}/.ssh/id_ed25519_autogitpush -o IdentitiesOnly=yes\" git push || true; fi; done'";
      };
      Install = { WantedBy = [ "default.target" ]; };
    };

    hermes-gateway = {
      Unit = {
        Description = "Hermes Agent Gateway - Messaging Platform Integration";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
        StartLimitIntervalSec = 0;
      };
      Service = {
        Type = "simple";
        WorkingDirectory = "/home/sn0w/.hermes";
        ExecStart = "/nix/store/b6ixk9y4qrn3gzbkm1xxjq2fkwvrd4k9-hermes-agent-env/bin/python -m hermes_cli.main gateway run";
        Environment = [
          "PATH=/nix/store/b6ixk9y4qrn3gzbkm1xxjq2fkwvrd4k9-hermes-agent-env/bin:/nix/store/h2barca1k5pmvcyl9fwrzwrb4cn1b248-nodejs-22.22.2/bin:/home/sn0w/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
          "VIRTUAL_ENV=/nix/store/b6ixk9y4qrn3gzbkm1xxjq2fkwvrd4k9-hermes-agent-env"
          "HERMES_HOME=/home/sn0w/.hermes"
        ];
        Restart = "always";
        RestartSec = 5;
        RestartForceExitStatus = 75;
        KillMode = "mixed";
        KillSignal = "SIGTERM";
        ExecReload = "/bin/kill -USR1 $MAINPID";
        ExecStopPost = "-/nix/store/b6ixk9y4qrn3gzbkm1xxjq2fkwvrd4k9-hermes-agent-env/bin/python -m gateway.cgroup_cleanup";
        TimeoutStopSec = 90;
        StandardOutput = "journal";
        StandardError = "journal";
      };
      Install = { WantedBy = [ "default.target" ]; };
    };
  };

  systemd.user.timers.autogitpush = {
    Unit = { Description = "Timer for autogitpush"; };
    Timer = {
      OnUnitActiveSec = "5min";
      Persistent = true;
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
