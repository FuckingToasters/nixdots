{ config, pkgs, unstablePkgs, inputs, userSettings,... }:

let
  sharedAliases = {
    v = "nvim";
    ll = "eza -lh --group-directories-first --icons";
    la = "eza -la --group-directories-first --icons";
    lt = "eza -lh --tree --icons";
    cat = "bat";
    dunst = "dunst -r";
    ping = "gping";
    dig = "doggo";
    diff = "delta";
    history = "mcfly";
    ps = "procs";
    gst = "git status";
    gcm = "git commit";
    gad = "git add";
    ncdu = "ncdu --exclude=/mnt --exclude=/nix";
    hyprupd = "flatpak update com.ml4w.dotfilesinstaller && hyprctl reload";
    nixchupd = "nix flake update";
    nixsearch = "nix search nixpkgs#";
    nixflake = "nano ~/dotfiles/workpc/flake.nix";
    nixconfig = "nano ~/dotfiles/workpc/configuration.nix";
    nixman = "nano ~/dotfiles/workpc/home.nix";
    nixapps = "nano ~/dotfiles/workpc/modules/apps.nix";
    nixservices = "nano ~/dotfiles/workpc/modules/services.nix";
    nixfilesystem = "nano ~/dotfiles/workpc/modules/filesystem.nix";
    nixfirewall = "nano ~/dotfiles/workpc/modules/firewall.nix";
    nixopti = "nix flake update && cleanup && rebuild";
    cavaconfig = "nano ~/.config/cava/config";
    hyprconfig = "nano ~/.config/hypr/hyprland.conf";
    hyprbinds = "nano ~/.config/hypr/conf/keybindings/default_modified.conf";
    lsend = "localsend_app";
    yt = "youtube-tui";
    cleanup = "sudo nix-collect-garbage --delete-older-than 7d && sudo nix store optimise";
    xclip = "xclip -selection clipboard";
    wcp = "wl-copy";
    printnix = "cat ~/dotfiles/workpc/configuration.nix | xclip";
    df = "df -h";
    c = "clear";
    teams = "teams-for-linux";
    onlyoffice = "onlyoffice-desktopeditors";
    venv = "source .venv/bin/activate";
    telegram = "telegram-desktop";
    rebuild = "nh os switch ~/dotfiles/workpc";
    rebuildmv = ''
      bash ~/.bashrc.bak 2>/dev/null || true
      bash ~/.zshrc.bak 2>/dev/null || true
      sudo nixos-rebuild switch --flake ~/dotfiles/workpc
    '';
  };

  sharedInitExtra = ''
    ${pkgs.fastfetch}/bin/fastfetch

    export HERMES_HOME="/home/henrikp/.hermes"

    hyprscripts() {
        if [ $# -eq 0 ]; then
          echo "==== hypr/scripts ===="
          echo "Usage: hyprscripts <filename>"
          ls ${config.home.homeDirectory}/.config/hypr/scripts/
          echo "==== ml4w/settings ===="
          ls ${config.home.homeDirectory}/.config/ml4w/settings/
          echo "==== ml4w/scripts ===="
          ls ${config.home.homeDirectory}/.config/ml4w/scripts/
          return 1
        fi

        nano ${config.home.homeDirectory}/.config/hypr/scripts/"$1"
        nano ${config.home.homeDirectory}/.config/ml4w/settings/"$1"
        nano ${config.home.homeDirectory}/.config/ml4w/scripts/"$1"
    }
  '';
in
{
  home.username = userSettings.username;
  home.homeDirectory = userSettings.homedir;
  home.stateVersion = "25.05";
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORM = "wayland";
    HERMES_HOME = "/home/henrikp/.hermes";
  };
  #home.extraGroups = [ "docker" ];
  # --- Example Kvantum theme setup (optional, for better Qt consistency) ---
  # You can reference your preferred Kvantum theme or use a system one.
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-Macchiato;
    '';
  };

  # mv ~/.gtkrc-2.0 ~/.gtkrc-2.0.hm-bakup
  # mv ~/.config/gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini.hm-bakup
  # mv ~/.config/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css.hm-bakup
  # mv ~/.config/gtk-4.0/settings.ini ~/.config/gtk-4.0/settings.ini.hm-bakup

  dconf.settings = {
     "org/gnome/desktop/interface" = {
       gtk-theme = "Catppuccin-Macchiato-Compact-Blue-Dark";
       icon-theme = "Papirus-Nord";
       cursor-theme = "Catppuccin-Mocha-Dark-Cursors";
       cursor-size = 24;
       color-scheme = "prefer-dark"; # optional: helps with apps that support it
     };
  };

  #virtualisation.docker.enable = true;
  #virtualisation.docker.composeEnable = true;

  home.packages = with pkgs; [
    # ========== Theme Packages ===========
    catppuccin-cursors # cursor theme
    papirus-nord # icon theme

    # ========== Personal Utilities ==========
    figlet
    qalculate-qt
    thunderbird
    localsend
    synology-drive-client
    qFlipper
    flameshot
    filezilla

    # ========== Terminals/CLI ==========
    wget
    rsync
    unzip
    jq
    inotify-tools
    flatpak
    neovim
    htop
    zsh
    zsh-completions
    eza # ls replacement
    fwupd
    yazi # TUI Filebrowser
    superfile # TUI Filebrowser
    cava
    fastfetch
    fzf # TUI File Search
    dust
    procs # ps replacement
    gping # ping replacement
    curlie # curl replacement
    doggo # dig dns replacement
    delta # file difference
    mcfly # shell history
    zoxide # cd replacement
    fprintd # fingerprint reader support
    matugen
    pastel
    unstablePkgs.youtube-tui
    rmpc # TUI Music Player
    ipcalc
    nix-search-tv
    whois
    gnupg
    ripgrep
    docker-compose
    ghostty
    iputils
    opencode

    # ========== File Management ==========
    kdePackages.dolphin

    # ========== Python & Dev ==========
    git
    rustc
    cargo
    python310
    steam-run
    go

    # ========== Media & Personal Apps ==========
    vlc
    mpv
    mpvScripts.sponsorblock
    imagemagick
    audacity
    calibre
    streamcontroller
    kdePackages.kdenlive
    lmms
    #spotify

    # ========== Personal Applications ==========
    tor-browser
    discord
    telegram-desktop
    obsidian
    nextcloud-client
    libreoffice
    onlyoffice-desktopeditors
    kdePackages.yakuake
    transmission_4-gtk
    distrobox
    teams-for-linux
    #sunshine
    wayvnc
    remmina
    steam

    # ========== VPN & Network (User-specific) ==========
    mullvad-vpn

    # ========== Personal System Utils ==========
    fuse2
    xdg-user-dirs
    acpid
    kdePackages.kleopatra
  ];

  systemd.user.services.autogitpush = {
    Unit = {
      Description = "Periodically auto git commit/push your repo";
    };
    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '
          cd ${config.home.homeDirectory}/dotfiles && git add . && git commit -m "auto" && git push
          cd ${config.home.homeDirectory}/.config && git add . && git commit -m "auto" && git push
        '
      '';
    };
  };

  systemd.user.timers.autogitpush = {
    Unit = {
      Description = "Timer for autogitpush";
    };
    Timer = {
      OnUnitActiveSec = "5min"; # adjust as you want
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  fonts.fontconfig = {
     enable = true;
     defaultFonts = {
        monospace = [ "Noto Sans Mono" "FontAwesome" ];
        sansSerif = [ "Noto Sans" "FontAwesome" ];
        emoji = ["Noto Color Emoji"];
     };
  };

  # --- GTK Theme Configuration (Legacy for GTK2 and non-debconf GTK3 Apps)---
  gtk = {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk;    # or pkgs.adw-gtk3, pkgs.breeze-gtk, etc.
      name = "Catppuccin-Macchiato-Compact-Blue-Dark";  # Check available variants or replace with what you prefer
    };
    iconTheme = {
      package = pkgs.papirus-nord; # or your favorite
      name = "Papirus-Nord";
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors;
      name = "Catppuccin-Mocha-Dark-Cursors";
      size = 24;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # --- Qt Theme Configuration ---
  qt = {
    enable = true;
    style = {
      package = pkgs.libsForQt5.qtstyleplugin-kvantum;  # Modern customizable style
      name = "kvantum";
    };
    platformTheme = {
      name = "qt5ct";    # Can also use "kde" if you prefer KDE Integration
    };
  };


  programs.home-manager.enable = true;
  #programs.kitty.enable = true;
  programs.wofi.enable = true;
  programs.waybar.enable = true;
  programs.swaylock.enable = true;
  #programs.nix-search-tv.enableTelevisionIntegration = true;

  nix = {
    enable = true;
    settings = {
      download-buffer-size = 524288000; # 500 MiB
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 7d";
    };
    #optimise = {
      #automatic = true;
      #dates = [ "3:45" ];
    #};
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # mv ~/./.bashrc ~/./bashrc.bak
  # mv ~/./.zshrc ~/./zshrc.bak
  programs.bash = {
    enable = true;
    shellAliases = sharedAliases;
    initExtra = sharedInitExtra;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "dallas"; # Or another OMZ theme you like
      plugins = [ "git" "colored-man-pages" "sudo" ]; # Any OMZ plugin, space separated
    };
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
    ];
    shellAliases = sharedAliases;
    initContent = sharedInitExtra;
  };

  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/dotfiles/workpc";
  };

  programs.git = {
    enable = true;
    userName = "FuckingToasters";
    userEmail = "adiscord128+github@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };


  programs.hyprpanel = {
    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {

      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null
      layout = {
        bar.layouts = {
          "0" = {
            left = [ "dashboard" "workspaces" ];
            middle = [ "media" ];
            right = [ "volume" "systray" "notifications" ];
          };
        };
      };

      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;

      theme.bar.transparent = true;

      theme.font = {
        name = "CaskaydiaCove NF";
        size = "16px";
      };
    };
  };
}
