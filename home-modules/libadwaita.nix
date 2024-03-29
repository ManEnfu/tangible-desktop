{ pkgs, config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.gtk.libadwaita;
  theme = config.gtk.theme.name;
  themeDir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0";
in {
  options.gtk.libadwaita = {
    enable = mkEnableOption "Link libadwaita";
  };

  config = mkIf (cfg.enable) {
    xdg.configFile = {
      "gtk-4.0/assets".source = "${themeDir}/assets";
      "gtk-4.0/gtk.css".source = "${themeDir}/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${themeDir}/gtk-dark.css";
    };
    
    home.sessionVariables = {
      GTK_THEME="${theme}";
    };
  };
}
