{ pkgs, config, lib, ... }: {
  imports = [
    ./awesome.nix
    ./hyprland.nix
    ./dwm.nix
  ];
}
