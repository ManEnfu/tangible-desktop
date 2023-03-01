{ pkgs, config, lib, ... }: {
  imports = [
    ./desktop
    ./kvantum.nix
    ./tangible.nix
    ./libadwaita.nix
  ];
}
