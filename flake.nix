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
        inherit (nixpkgs) lib;

        pkgs = import nixpkgs { inherit system; };

        releases = import ./nix/releases.nix;

        archs = [
          "armv7hf"
          "aarch64"
        ];

        sdk =
          release: targetArch: pkgs.callPackage ./nix/acap-native-sdk.nix { inherit release targetArch; };

        packagesFor =
          major: release:
          lib.listToAttrs (
            map (
              targetArch: lib.nameValuePair "acap-native-sdk-${major}-${targetArch}" (sdk release targetArch)
            ) archs
          );
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        packages = lib.concatMapAttrs packagesFor releases;

        checks = self.packages.${system};

        devShells.default = pkgs.mkShellNoCC {
          nativeBuildInputs = [
            pkgs.nixfmt-rfc-style
          ];
        };
      }
    );
}
