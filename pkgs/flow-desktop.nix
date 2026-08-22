# Flow Desktop - Tauri v2 YouTube / YouTube Music client
# Built with the nixpkgs cargo-tauri hook:
#   https://nixos.org/manual/nixpkgs/unstable/#tauri-hook
{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  cargo-tauri,
  pkg-config,
  openssl,
  glib-networking,
  webkitgtk_4_1,
  gst_all_1,
  wrapGAppsHook4,
  nodejs_22,
  pnpm_11,
  pnpmConfigHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flow-desktop";
  version = "0.1.0-beta";

  src = fetchFromGitHub {
    owner = "Flow-Tube";
    repo = "Flow-Desktop";
    rev = "60f6e8121ef7ec4fff5affe02a3552619540ef59";
    hash = "sha256-S1iH/BsNkXeb1monygzXLXlfavunsUq8ivcjuDcNovQ=";
  };

  # Frontend deps (Vite + React), installed offline by pnpmConfigHook
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-DXKpvlEyHJzer93vu3o7cNuQfVw17W1L7RhPiXmvHGg=";
  };

  cargoHash = "sha256-ejZAmJvUsAqKyvrr2ESYjTMkofk9vyqcQqRVfxTDBWI=";

  # The updater plugin would try to sign release artifacts and demand
  # TAURI_SIGNING_PRIVATE_KEY; disable updater artifact creation.
  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
  '';

  nativeBuildInputs = [
    # Main tauri hook (replaces build/install phases with `cargo tauri build`)
    cargo-tauri.hook

    nodejs_22
    pnpm_11
    pnpmConfigHook
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    openssl
    webkitgtk_4_1
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-libav # h264/aac decode for playback
  ]);

  # Rust sources live in src-tauri, frontend in the repo root.
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  # Tests need a display/network; skip them.
  doCheck = false;

  meta = {
    description = "Privacy-first YouTube and YouTube Music desktop companion to Flow for Android";
    homepage = "https://github.com/Flow-Tube/Flow-Desktop";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "flow";
  };
})
