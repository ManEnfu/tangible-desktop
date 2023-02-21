{ pkgs
, config
, lib
, ...
}:

with lib;
with builtins;
let 
  cfg = config.desktop.tangible;
in {
  options.desktop.tangible.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  config  = mkIf cfg.hyprland.enable {
    home.file = {
      ".config/hypr" = {
        source = if cfg.mutableConfig 
          then config.lib.file.mkOutOfStoreSymlink "${cfg.mutableConfigDir}/desktop/hypr"
          else ../../desktop/hypr;
      };
    };
  };
}
