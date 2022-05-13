{ pkgs, config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.desktopConfig.tangible;
  configDir = ./.;
in {
  options.desktopConfig.tangible = {
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
    ];

    gtk = {
      # enable = true;
      iconTheme = {
        package = pkgs.tela-icon-theme;
        name = "Tela-dark";
      };
      theme = {
        package = pkgs.materia-theme;
        name = "Materia-dark-compact";
      };
    };

    qt = {
      # enable = true;
      platformTheme = "gtk";
      style = {
        package = pkgs.libsForQt5.qtstyleplugins;
        name = "gtk2";
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
        source = "${configDir}/picom";
        recursive = true;
      };
      "scripts" = {
        source = "${configDir}/scripts";
        recursive = true;
      };
    };
  };
}
