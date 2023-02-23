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
  options.desktop.tangible.qtile = {
    enable = mkEnableOption "Awesome";
  };

  config  = mkIf cfg.qtile.enable {
    home.file = {
      ".config/qtile" = {
        source = if cfg.mutableConfig 
          then mkSymlink "${cfg.mutableConfigDir}/desktop/qtile"
          else ../../desktop/qtile;
      };
    };
  };
}
