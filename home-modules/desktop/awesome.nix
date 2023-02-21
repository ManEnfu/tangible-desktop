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
  options.desktop.tangible.awesome = {
    enable = mkEnableOption "Awesome";
  };

  config  = mkIf cfg.awesome.enable {
    home.file = {
      ".config/awesome" = {
        source = if cfg.mutableConfig 
          then mkSymlink "${cfg.mutableConfigDir}/desktop/awesome"
          else ../../desktop/awesome;
      };
    };
  };
}
