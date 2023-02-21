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
        source = if cfg.mutableConfig 
          then config.lib.file.mkOutOfStoreSymlink "${cfg.mutableConfigDir}/desktop/hypr"
          else ./.;
      };
    };

    # systemd.user.targets.tgd-hyprland-session = {
    #   Unit = {
    #     Description = "Tangible desktop session - Hyprland";
    #     BindsTo = ["graphical-session.target"];
    #     Wants = ["graphical-session-pre.target"];
    #     After = ["graphical-session-pre.target"];
    #   };
    # };

    # systemd.user.targets.tgd-hyprland-wallpaper = {
    #   Unit = {
    #     Description = "Tangible desktop session - Hyprland - wallpaper";
    #     PartOf = ["graphical-session.target"];
    #   };
    #   Service = {
    #     ExecStart = "${lib.getExe pkgs.swaybg}"
    #   }
    # }
  };
}
