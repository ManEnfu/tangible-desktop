{
  outputs = { self, nixpkgs }: {
    nixosModule = import ./modules;
  };
}
