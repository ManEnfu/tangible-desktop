{ pkgs, config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.qt.kvantum;
  configDir = ../.;
in {
  options.qt.kvantum = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable";
    };
    
    theme = {
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = "package";
      };
      name = mkOption {
        type = types.str;
        default = "";
        description = "package name";
      };
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      cfg.theme.package
    ];

    qt = {
      platformTheme = "gtk";
      style = {
        name = "kvantum-dark";
      };
    };

    xdg.configFile = {
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=${cfg.theme.name}
      '';
      "Kvantum/${cfg.theme.name}" = {
        source = "${cfg.theme.package}/share/Kvantum/${cfg.theme.name}";
        recursive = true;
      };
    };
  };
}
