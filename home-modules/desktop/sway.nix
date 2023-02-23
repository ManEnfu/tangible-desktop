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
  options.desktop.tangible.sway = {
    enable = mkEnableOption "Awesome";
  };

  config  = mkIf cfg.sway.enable {
    home.file = {
      ".config/sway" = {
        source = if cfg.mutableConfig 
          then mkSymlink "${cfg.mutableConfigDir}/desktop/sway"
          else ../../desktop/sway;
      };
    };
  };
}
