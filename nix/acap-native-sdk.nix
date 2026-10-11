{
  lib,
  stdenvNoCC,
  dockerTools,
  jq,
  release,
  targetArch,
}:
let
  inherit (release) version ubuntuTag;

  image = dockerTools.pullImage {
    imageName = "axisecp/acap-native-sdk";
    finalImageName = "axisecp/acap-native-sdk";
    finalImageTag = "${version}-${targetArch}-${ubuntuTag}";
    inherit (release.images.${targetArch}) imageDigest sha256;
    os = "linux";
    arch = "amd64";
  };
in
stdenvNoCC.mkDerivation {
  pname = "acap-native-sdk-${targetArch}";
  inherit version;

  dontUnpack = true;

  # Keep the SDK byte-for-byte as shipped: no RPATH shrinking, shebang
  # patching, stripping, or symlink checks. The sysroots contain dangling
  # symlinks by design and patching their ELF files would corrupt the
  # cross-compilation toolchain.
  dontFixup = true;

  nativeBuildInputs = [ jq ];

  # Flatten the image and keep `/opt/axis`. Layers are applied in order so that
  # later layers win, matching how a container sees the filesystem. Each layer
  # is streamed straight out of the image tarball to avoid materialising every
  # layer on disk at once.
  buildPhase = ''
    runHook preBuild

    mkdir -p "$out"
    work="$(mktemp -d)"
    image=${lib.escapeShellArg image}

    tar -xf "$image" -C "$work" manifest.json
    for layer in $(jq -r '.[0].Layers[]' "$work/manifest.json"); do
      tar -xOf "$image" "$layer" | tar -t > "$work/entries"
      grep -q '^opt/axis/' "$work/entries" || continue

      # The SDK ships read-only directories, and the build runs as an
      # unprivileged user that cannot bypass directory permissions. Make every
      # directory extracted so far writable so the next layer can create
      # entries inside them, and so that whiteouts can delete from them.
      find "$out" -type d ! -perm -u+w -exec chmod u+w {} +

      sed -n 's|^opt/axis/\(.*/\)\{0,1\}\.wh\.\([^/]*\)$|\1\2|p' "$work/entries" \
        | while IFS= read -r victim; do rm -rf "$out/$victim"; done

      tar -xOf "$image" "$layer" \
        | tar -x -C "$out" \
            --strip-components 2 \
            --no-same-owner \
            --delay-directory-restore \
            --exclude='.wh.*' \
            'opt/axis'
    done
    rm -rf "$work"

    runHook postBuild
  '';

  dontInstall = true;

  meta = {
    description = "ACAP Native SDK for ${targetArch}, extracted from the official Docker images";
    homepage = "https://github.com/AxisCommunications/acap-native-sdk";
    platforms = lib.platforms.all;
  };
}
