{
  description = "Nix facilities for ACAP development";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        acap-native-sdk = pkgs.callPackage ./nix/acap-native-sdk.nix { };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        packages = { inherit acap-native-sdk; };

        checks = self.packages.${system};

        devShells.default = pkgs.mkShellNoCC {
          nativeBuildInputs = [
            pkgs.nixfmt-rfc-style
          ];
        };
      }
    );
}
