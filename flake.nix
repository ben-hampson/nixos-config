{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Downloads Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
    
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
          # Passes inputs from this flake into every module listed below.
          specialArgs = {inherit inputs;};
          modules = [ 
            ./configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };

    };
}
