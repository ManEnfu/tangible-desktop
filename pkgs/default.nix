{ pkgs }: {
  picom-jonaburg = pkgs.callPackage ./picom-jonaburg.nix {};
  tangible-icons = pkgs.callPackage ./tangible-icons.nix {};
}
