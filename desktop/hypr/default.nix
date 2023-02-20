{ pkgs
, config
, lib
, ...
}:

with lib;
with builtins;
let 
  cfg = config.desktop.tangible.hyprland;
in {
  options.desktop.tangible.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  config  = mkIf cfg.enable {
    home.packages = with pkgs; [
      lxde.lxsession
      libnotify
      pulseaudio
      brightnessctl
      lxqt.pacmanfm-qt
      dunst
      rofi-wayland
      kitty
      networkmanagerapplet
      playerctl
      hyprpaper
      hyprpicker
      tangible.waybar-hyprland-workspace-fix
      wl-clipboard
      eww-wayland
      libappindicator-gtk3
      swaybg
      socat
      grim
      slurp
      wev
      jq
      tangible-icons
    ];

    home.file = {
      ".config/hypr" = {
        source = ./.;
      };
    };
  };
}
