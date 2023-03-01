{ pkgs
, config
, lib
, ... 
}:

with lib;
with builtins;
let
  cfg = config.desktop.tangible;
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  getConfigDir = if cfg.mutableConfig
    then path: config.lib.file.mkOutOfStoreSymlink "${cfg.mutableConfigDir}/${path}" 
    else path: ../${path};
in {
  options.desktop.tangible = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Tangible desktop configurations";
    };
    mutableConfig = mkOption {
      type = types.bool;
      default = false;
      description = "Make installed config files mutable ";
    };
    mutableConfigDir = mkOption {
      type = types.str;
      description = "Location of a local copy of this repositor";
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      # Desktop Apps
      gnome.nautilus
      lxde.lxsession
      libnotify
      pulseaudio
      brightnessctl
      lxqt.pcmanfm-qt
      dunst
      rofi-wayland
      kitty

      # X11 Stuffs
      tangible.picom-jonaburg
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

      # Hypr 
      hyprpaper
      hyprpicker
      
      # Wayland Stuffs
      tangible.waybar-hyprland-workspace-fix
      wl-clipboard
      eww-wayland
      libappindicator-gtk3
      swaybg
      socat
      grim
      slurp
      
      wev

      (python310.withPackages (p: with p; [
        pulsectl
        watchdog
      ]))
      jq

      tangible-icons
      tangible-desktop-scripts

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
        # package = pkgs.materia-theme;
        # name = "Materia-dark-compact";
        package = (pkgs.orchis-theme.overrideAttrs (f: p: rec {
          version = "2023-02-26";
          src = pkgs.fetchFromGitHub {
            repo = "Orchis-theme";
            owner = "vinceliuice";
            rev = version;
            sha256 = "sha256-Qk5MK8S8rIcwO7Kmze6eAl5qcwnrGsiWbn0WNIPjRnA=";
          };

          preInstall = ''
            sed -i 's/make_gtkrc "''${dest:-$DEST_DIR}" "''${name:-$THEME_NAME}" "$theme" "$color" "$size" "$ctype"/make_gtkrc "''${dest:-$DEST_DIR}" "''${_name:-$THEME_NAME}" "$theme" "$color" "$size" "$ctype"/' core.sh
          '' + p.preInstall;
        })).override {
          border-radius = 6;
          tweaks = [ "solid" "compact" "black" ];
        };
        name = "Orchis-Dark-Compact";
      };
      font = {
        package = pkgs.ubuntu_font_family;
        name = "Ubuntu";
        size = 9;
      };
      libadwaita.enable = true;
    };

    qt = {
      enable = true;
      kvantum = {
        enable = true;
        theme = {
          package = pkgs.materia-kde-theme;
          name = "MateriaDark";
          # package = pkgs.orchis-kde-theme;
          # name = "Orchis-dark";
        };
      };
    };

    home.sessionVariables = {
      XCURSOR_SIZE = "24";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM="wayland;xcb";
    };

    home.file = {
      # ".config/awesome" = {
      #   source = getConfigDir "./awesome";
      #   # recursive = true;
      # };
      # ".config/alacritty" = {
      #   source = getConfigDir "./alacritty";
      #   # recursive = true;
      # };
      ".config/kitty" = {
        source = if cfg.mutableConfig 
          then mkSymlink "${cfg.mutableConfigDir}/config/kitty"
          else ../config/kitty;
      };
      # ".config/picom" = {
      #   source = getConfigDir "./picom";
      #   # recursive = true;
      # };
      # ".config/rofi" = {
      #   source = getConfigDir "./rofi";
      #   # recursive = true;
      # };
      # ".config/scripts" = {
      #   source = getConfigDir "./scripts";
      #   # recursive = true;
      # };
      # ".config/qtile" = {
      #   source = getConfigDir "./qtile";
      #   # recursive = true;
      # };
      # ".config/hypr" = {
      #   source = ../desktop/hypr;
      # };
      # ".config/dunst" = {
      #   source = getConfigDir "./dunst";
      # };
      # ".config/river" = {
      #   source = getConfigDir "./river";
      # };
      # ".config/libinput-gestures.conf" = {
      #   source = getConfigDir "./libinput-gestures.conf";
      # };
    };
  };
}
