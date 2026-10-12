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

        releases = import ./nix/releases.nix;

        sdk =
          release: targetArch: pkgs.callPackage ./nix/acap-native-sdk.nix { inherit release targetArch; };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        packages = rec {
          acap-native-sdk-12-armv7hf = sdk releases."12" "armv7hf";
          acap-native-sdk-12-aarch64 = sdk releases."12" "aarch64";
          acap-native-sdk-12 = pkgs.callPackage ./nix/acap-native-sdk-all-arches.nix {
            inherit (releases."12") version;
            sdks = [
              acap-native-sdk-12-armv7hf
              acap-native-sdk-12-aarch64
            ];
          };

          acap-native-sdk-13-armv7hf = sdk releases."13" "armv7hf";
          acap-native-sdk-13-aarch64 = sdk releases."13" "aarch64";
          acap-native-sdk-13 = pkgs.callPackage ./nix/acap-native-sdk-all-arches.nix {
            inherit (releases."13") version;
            sdks = [
              acap-native-sdk-13-armv7hf
              acap-native-sdk-13-aarch64
            ];
          };

          acap-ssh-utils = pkgs.callPackage ./nix/acap-ssh-utils.nix { };
          cargo-acap-build = pkgs.callPackage ./nix/cargo-acap-build.nix { };
          cargo-acap-sdk = pkgs.callPackage ./nix/cargo-acap-sdk.nix { };

          cli4a = pkgs.callPackage ./nix/cli4a.nix { };
          device-finder = pkgs.callPackage ./nix/device-finder.nix { };
          device-inventory = pkgs.callPackage ./nix/device-inventory.nix { };
          device-manager = pkgs.callPackage ./nix/device-manager.nix { };
          fimage = pkgs.callPackage ./nix/fimage.nix { };
          firmware-inventory = pkgs.callPackage ./nix/firmware-inventory.nix { };
        };

        checks = self.packages.${system};

        devShells.default = pkgs.mkShellNoCC {
          nativeBuildInputs = [
            pkgs.nixfmt-rfc-style
          ];
        };
      }
    );
}
