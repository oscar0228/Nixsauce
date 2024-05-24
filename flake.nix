{
description = "Walz homelab flake configs";

inputs = {
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
};
outputs = { self, nixpkgs }@inputs:
  {
    nixosConfigurations = {
      saturn = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
      };
    };
  };
}
