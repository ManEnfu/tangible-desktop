{ pkgs, config, lib, ... }: {
  imports = [
    ./kvantum.nix
    ./tangible.nix
    ./river.nix
  ];
}
