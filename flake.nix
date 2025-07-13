{
  description = "estromenko nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;
    nixosConfigurations.estromenko = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/estromenko/configuration.nix
        ./hosts/estromenko/hardware-configuration.nix
        inputs.chaotic.nixosModules.default
      ];
    };
    homeConfigurations.estromenko = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        inputs.niri.homeModules.niri
        inputs.chaotic.homeManagerModules.default
        ./hosts/estromenko/home-manager/home.nix
      ];
      extraSpecialArgs = {inherit inputs;};
    };
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [nil nixd];
    };
  };
}
