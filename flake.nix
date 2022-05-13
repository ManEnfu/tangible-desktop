{
  outputs = { self, nixpkgs }: {
    nixosModules = import ./modules;
  };
}
