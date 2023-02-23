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

    systemd.user.targets.tgd-hyprland-session = {
      Unit = {
        Description = "Tangible desktop - hyprland compositor session";
        Documentation = ["man:systemd.special(7)"];
        BindsTo = ["graphical-session.target"];
        Wants = ["graphical-session-pre.target"];
        After = ["graphical-session-pre.target"];
      };
    };

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };
  };

}
