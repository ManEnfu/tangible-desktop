{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.river;
in {
  options.programs.river = {
    enable = mkEnableOption "Enable River";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.river ];
    };
    security.polkit.enable = true;
    hardware.opengl.enable = mkDefault true;
    fonts.enableDefaultFonts = mkDefault true;
    programs.dconf.enable = mkDefault true;
    # To make a Sway session available if a display manager like SDDM is enabled:
    # services.xserver.displayManager.sessionPackages = [ pkgs.river ];
    programs.xwayland.enable = mkDefault true;
    # For screen sharing (this option only has an effect with xdg.portal.enable):
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
}
