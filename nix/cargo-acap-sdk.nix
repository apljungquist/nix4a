{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "cargo-acap-sdk";
  version = "0.3.1+5eed2e27";

  src = fetchFromGitHub {
    owner = "AxisCommunications";
    repo = "acap-rs";
    rev = "5eed2e27fcb2a83e4d42ef71ccd49039949e9cca";
    hash = "sha256-4k/tA3o9/cISy1Yp5O30A6FUBoW/hoxM1MHhQT4dvHc=";
  };

  cargoHash = "sha256-yhIbPH6xxSJI8u7TupirLcPuBUPO2zgZoYyRw4RPBZc=";

  buildAndTestSubdir = "crates/cargo-acap-sdk";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "Automation of common ACAP development workflows";
    homepage = "https://github.com/AxisCommunications/acap-rs";
    license = lib.licenses.mit;
    mainProgram = "cargo-acap-sdk";
  };
}
