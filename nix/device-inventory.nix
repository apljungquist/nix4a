{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "device-inventory";
  version = "0.1.1+e7048af4";

  src = fetchFromGitHub {
    owner = "apljungquist";
    repo = "rs4a";
    rev = "e7048af49356ff7689d62a1c5aee2c4dd559141c";
    hash = "sha256-g3c0Seo+OmaaSU3k33Yh9G3Zv7jsvxkWV6MU9l1ybFc=";
  };

  cargoHash = "sha256-n0PSYKKGncQQDEJ6R5OGH81xs54k0VCPVHpbeG0bkps=";

  buildAndTestSubdir = "crates/device-inventory";

  meta = {
    description = "Utilities for tracking multiple devices";
    homepage = "https://github.com/apljungquist/rs4a";
    mainProgram = "device-inventory";
  };
}
