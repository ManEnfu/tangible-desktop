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
  options.desktop.tangible.river = {
    enable = mkEnableOption "Awesome";
  };

  config  = mkIf cfg.river.enable {
    home.file = {
      ".config/river" = {
        source = if cfg.mutableConfig 
          then mkSymlink "${cfg.mutableConfigDir}/desktop/river"
          else ../../desktop/river;
      };
    };
  };
}
