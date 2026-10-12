{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "acap-ssh-utils";
  version = "0.2.0+5eed2e27";

  src = fetchFromGitHub {
    owner = "AxisCommunications";
    repo = "acap-rs";
    rev = "5eed2e27fcb2a83e4d42ef71ccd49039949e9cca";
    hash = "sha256-4k/tA3o9/cISy1Yp5O30A6FUBoW/hoxM1MHhQT4dvHc=";
  };

  cargoHash = "sha256-yhIbPH6xxSJI8u7TupirLcPuBUPO2zgZoYyRw4RPBZc=";

  buildAndTestSubdir = "crates/acap-ssh-utils";

  meta = {
    description = "Utilities for interacting with Axis devices over SSH";
    homepage = "https://github.com/AxisCommunications/acap-rs";
    license = lib.licenses.mit;
    mainProgram = "acap-ssh-utils";
  };
}
