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
  options.desktop.tangible.dwm = {
    enable = mkEnableOption "Awesome";
  };

  config  = mkIf cfg.dwm.enable {
    home.packages = with pkgs; [
      dwm-tangible
      dmenu-tangible
      dwmblocks-tangible
      st-tangible
    ];
  };
}
