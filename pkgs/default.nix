{ pkgs }: {
  picom-jonaburg = pkgs.callPackage ./picom-jonaburg.nix {};
  tangible-icons = pkgs.callPackage ./tangible-icons.nix {};
  tangible-desktop-scripts = pkgs.callPackage ./tangible-desktop-scripts.nix {};
}
