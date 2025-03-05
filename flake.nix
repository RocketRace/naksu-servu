{
  description = "my nix server iso";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
  }: {
    nixosConfigurations =
      let base = {
        system = "x86_64-linux";
        modules = [
          # hardware requirements
          nixos-hardware.nixosModules.apple-macbook-pro-11-1
          # required for proprietary drivers
          { nixpkgs.config.allowUnfree = true; }
        ];
      }; in {
        iso = nixpkgs.lib.nixosSystem base;
        real = nixpkgs.lib.nixosSystem (
          base // {
            modules = [
              # add modules here if necessary
              {
                services.tailscale.enable = true;
              }
            ];
          }
        );
      };
  };
}
