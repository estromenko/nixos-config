{
  description = "estromenko nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    nixosConfigurations.estromenko = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [./hosts/estromenko/configuration.nix ./hosts/estromenko/hardware-configuration.nix];
    };
    homeConfigurations.estromenko = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        inputs.ironbar.homeManagerModules.default
        inputs.niri.homeModules.niri
        ./hosts/estromenko/home-manager/home.nix
      ];
      extraSpecialArgs = {inherit inputs;};
    };
  };
}
