{
  lib,
  stdenvNoCC,
  sdks,
  version,
}:
let
  sdkPaths = lib.escapeShellArgs sdks;
in
stdenvNoCC.mkDerivation {
  pname = "acap-native-sdk";
  inherit version;

  dontUnpack = true;
  dontFixup = true;

  buildPhase = ''
    runHook preBuild

    mkdir -p "$out"
    for sdk in ${sdkPaths}; do
      cp -dRf "$sdk/." "$out/"
      find "$out" -type d ! -perm -u+w -exec chmod u+w {} +
    done

    runHook postBuild
  '';

  dontInstall = true;

  meta = {
    description = "ACAP Native SDK for all target architectures";
    platforms = lib.platforms.all;
  };
}
