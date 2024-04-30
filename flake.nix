{
  description = "SMAPI, The mod loader for Stardew Valley. Now with Flakes!";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    flake-parts,
    self,
    systems,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;

      imports = [
        ./pkgs
        ./modules/devshell.nix
      ];

      flake = {
        homeManagerModules = {
          nix-smapi = import ./modules/home-manager.nix self;
          default = self.homeManagerModules.nix-smapi;
        };
      };
    };
}
