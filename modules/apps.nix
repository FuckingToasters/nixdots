{ config, pkgs, ... }:

{
   
  # ========== System-wide Packages ==========
  environment.systemPackages = with pkgs; [
    # ========== Wayland/Hyprland & Desktop Environment ==========
    hyprland
    hyprpaper
    hyprpanel
    hyprlock
    hypridle
    hyprpicker
    hyprshade
    hyprcursor
    swaylock
    swaynotificationcenter
    swayidle
    waybar
    wlogout
    grim
    grimblast
    slurp
    wl-clipboard
    cliphist
    niri
    waypaper
    wofi
    fuzzel
    rofi-wayland
    nwg-look
    nwg-dock-hyprland
    uwsm
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    pyprland
    swww
    wdisplays

    # ========== Development Tools ==========
    kdePackages.kate
    rustup
    gcc
    zig
    lua
    hugo

    # ========== Media & Creative (System Tools) ==========
    beets
    ffmpeg-full
    mpv

    # ========== System & Network ==========
    libnotify
    xwayland-satellite 
    tmux
    vorta
    killall
    ranger
    curl
    zoxide
    borgbackup
    trash-cli
    util-linux
    ncdu
    caligula
    wireguard-tools

    # ========== Terminal & Shell ==========
    kitty
    fish
    oh-my-posh
    bat
    fd
    btop
    pulsemixer
    stow

    # ========== Python & Package Management ==========
    python312Packages.pip
    pipx
    pywalfox-native
    pywal16

    # ========== System Utilities ==========
    gum
    xclip
    power-profiles-daemon
    brightnessctl
    playerctl
    kdePackages.kwallet

    # ========== Networking ==========
    #networkmanagerapplet
    iwd
    blueman
    gvfs

    # ========== Fonts, Icons, Themes ==========
    noto-fonts
    noto-fonts-emoji
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-extra
    font-awesome
    dejavu_fonts
    fira-sans
    fira-code
    nerd-fonts.fira-code
    papirus-icon-theme
    kdePackages.breeze
    bibata-cursors

    # ========== GTK/Qt/Graphical Toolkit ==========
    gtk4
    qt6ct
    libadwaita

    # ========== System Infrastructure ==========
    nfs-utils
  ];
  # ========== System-wide Programs ==========
  programs.virt-manager.enable = true;
  programs.niri.enable = true;
  programs.hyprland.enable = true;
  programs.sway.enable = true;
  programs.nh.enable = true;
  programs.firefox.enable = true;

  #programs.steam = {
   #enable = true;
   #extraCompatPackages = [ pkgs.proton-ge-bin ];   
  #};

  services.flatpak.packages = [
    "com.obsproject.Studio"
    "com.ticktick.TickTick"
    #"com.vivaldi.Vivaldi"
    #"org.gimp.GIMP"
    "us.zoom.Zoom"
    "page.codeberg.libre_menu_editor.LibreMenuEditor"
    #"com.heroicgameslauncher.hgl"
    "io.github.dvlv.boxbuddyrs"
    "com.vscodium.codium"
    "com.spotify.Client"
    "org.kde.kate"

  ];
}
