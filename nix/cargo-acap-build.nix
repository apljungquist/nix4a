{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "cargo-acap-build";
  version = "0.1.0+5eed2e27";

  src = fetchFromGitHub {
    owner = "AxisCommunications";
    repo = "acap-rs";
    rev = "5eed2e27fcb2a83e4d42ef71ccd49039949e9cca";
    hash = "sha256-4k/tA3o9/cISy1Yp5O30A6FUBoW/hoxM1MHhQT4dvHc=";
  };

  cargoHash = "sha256-yhIbPH6xxSJI8u7TupirLcPuBUPO2zgZoYyRw4RPBZc=";

  buildAndTestSubdir = "crates/cargo-acap-build";

  meta = {
    description = "Build utilities for ACAP apps and other executables deployed to Axis devices";
    homepage = "https://github.com/AxisCommunications/acap-rs";
    license = lib.licenses.mit;
    mainProgram = "cargo-acap-build";
  };
}
