{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixos-hardware,
    ...
  }:
  {
    nixosConfigurations."caique" = nixpkgs.lib.nixosSystem {
      system = "x86_84-linux";
      modules = [
        nixos-hardware.nixosModules.apple-macbook-pro-11-1
        ./configuration.nix
      ];
    };
  };
}