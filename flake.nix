{
  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpicker.url = "github:hyprwm/hyprpicker";
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    
    overlay-tangible = final: prev: {
      # extra = import ./pkgs { pkgs = import nixpkgs { inherit system; }; };
      tangible.picom-jonaburg = pkgs.callPackage ./pkgs/picom-jonaburg.nix {};
      tangible-icons = pkgs.callPackage ./pkgs/tangible-icons.nix {};
      tangible.waybar-hyprland-workspace-fix = prev.waybar.overrideAttrs (oldAttrs: {
        preConfigure = ''
          sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp # use hyprctl to switch workspaces
        '';
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
    };
    overlay-hyprpaper = inputs.hyprpaper.overlays.default;
    overlay-hyprpicker = inputs.hyprpicker.overlays.default;
  in {
    homeModule = { 
      nixpkgs.overlays = [ 
        overlay-tangible 
        overlay-hyprpaper
        overlay-hyprpicker
      ];
      imports = [ ./home-modules ]; 
    };

    packages.${system} = overlay-tangible null pkgs;
  };
}
