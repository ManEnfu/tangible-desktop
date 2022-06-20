{ pkgs, config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.desktop.tangible;
  configDir = ../.;
in {
  options.desktop.tangible = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable";
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      rofi
      alacritty
      lxqt.pcmanfm-qt
      picom
      feh
      redshift
      networkmanagerapplet
      lxde.lxsession
      scrot
      playerctl
      libinput-gestures
      libnotify
      wmctrl

      (nerdfonts.override { fonts = [ "Ubuntu" "JetBrainsMono" ]; })
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

    xdg.configFile = {
      "awesome" = {
        source = "${configDir}/awesome";
        recursive = true;
      };
      "alacritty" = {
        source = "${configDir}/alacritty";
        recursive = true;
      };
      "picom" = {
        source = "${configDir}/picom";
        recursive = true;
      };
      "rofi" = {
        source = "${configDir}/rofi";
        recursive = true;
      };
      "scripts" = {
        source = "${configDir}/scripts";
        recursive = true;
      };
      "libinput-gestures.conf" = {
        source = "${configDir}/libinput-gestures.conf";
      };
    };
  };
}
