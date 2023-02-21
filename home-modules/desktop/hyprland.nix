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
in {
  options.desktop.tangible.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  config  = mkIf cfg.hyprland.enable {
    home.file = {
      ".config/hypr" = {
        source = if cfg.mutableConfig 
          then mkSymlink "${cfg.mutableConfigDir}/desktop/hypr"
          else ../../desktop/hypr;
      };
    };
  };
}
