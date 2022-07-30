{ pkgs, config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.desktop.tangible;
  configDir = "/etc/nixos/tangible-desktop";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  getConfigDir = if cfg.mutableConfig
    then path: config.lib.file.mkOutOfStoreSymlink "${mutableConfigDir}/${path}"; 
    else path: ../${path};
in {
  options.desktop.tangible = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable";
    };
    mutableConfig = mkOption {
      type = types.bool;
      default = false;
      description = "mutableConfig";
    };
    mutableConfigDir = mkOption {
      type = types.string;
      description = "mutableConfigDir";
    };
    awesome = mkEnableOption "awesome";
    qtile = mkEnableOption "qtile";
    qtile-wayland = mkEnableOption "qtile (wayland)";
    hyprland = mkEnableOption "hyprland";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      # Desktop Apps
      lxde.lxsession
      libnotify
      pulseaudio
      brightnessctl
      lxqt.pcmanfm-qt
      dunst
      rofi-wayland

      # X11 Stuffs
      alacritty
      extra.picom-jonaburg
      feh
      redshift
      networkmanagerapplet
      scrot
      playerctl
      libinput-gestures
      wmctrl
      gcolor3
      i3lock
      xcolor
      
      # Wayland Stuffs
      wofi
      waybar-hyprland-workspace-fix
      wev
      wl-clipboard
      libappindicator-gtk3
      swaybg
      socat

      (nerdfonts.override { fonts = [ "Ubuntu" "JetBrainsMono" "FiraCode" ]; })
    ];

    home.pointerCursor = {
        package = pkgs.quintom-cursor-theme;
        name = "Quintom_Ink";
        size = 24;
        gtk.enable = true; 
    };

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.tela-icon-theme;
        name = "Tela-dark";
      };
      theme = {
        package = pkgs.materia-theme;
        name = "Materia-dark-compact";
      };
      font = {
        package = pkgs.ubuntu_font_family;
        name = "Ubuntu";
        size = 8;
      };
    };

    qt = {
      enable = true;
      kvantum = {
        enable = true;
        theme = {
          package = pkgs.materia-kde-theme;
          name = "MateriaDark";
        };
      };
    };

    home.sessionVariables = {
      XCURSOR_SIZE = "24";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM="wayland;xcb";
    };

    home.file = {
      ".config/awesome" = {
        source = getConfigDir "./awesome";
        # recursive = true;
      };
      ".config/alacritty" = {
        source = getConfigDir "./alacritty";
        # recursive = true;
      };
      ".config/picom" = {
        source = getConfigDir "./picom";
        # recursive = true;
      };
      ".config/rofi" = {
        source = getConfigDir "./rofi";
        # recursive = true;
      };
      ".config/scripts" = {
        source = getConfigDir "./scripts";
        # recursive = true;
      };
      ".config/qtile" = {
        source = getConfigDir "./qtile";
        # recursive = true;
      };
      ".config/libinput-gestures.conf" = {
        source = getConfigDir "./libinput-gestures.conf";
      };
    };
  };
}