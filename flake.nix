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
  let state-version = "24.11";
  in {
    nixosConfigurations."caique" = nixpkgs.lib.nixosSystem {
      system = "x86_84-linux";
      modules = [
        nixos-hardware.nixosModules.apple-macbook-pro-11-1
        ./configuration.nix
        import ./services.nix {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          inherit inputs state-version;
        }
      ];
    };
  };
}