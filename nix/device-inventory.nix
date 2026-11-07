{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "device-inventory";
  version = "0.1.1+a61e47b3";

  src = fetchFromGitHub {
    owner = "apljungquist";
    repo = "rs4a";
    rev = "a61e47b37cbd30c825395fec6529420d859249de";
    hash = "sha256-15ooEvDxuiwkcXEWnDbfpnTOAe9Ir9dZB9VDYuKayho=";
  };

  cargoHash = "sha256-n0PSYKKGncQQDEJ6R5OGH81xs54k0VCPVHpbeG0bkps=";

  buildAndTestSubdir = "crates/device-inventory";

  meta = {
    description = "Utilities for tracking multiple devices";
    homepage = "https://github.com/apljungquist/rs4a";
    mainProgram = "device-inventory";
  };
}
