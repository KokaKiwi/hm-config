{ lib, stdenv

, fetchFromGitHub

, rustPlatform

, pkg-config
, python3

, openssl
, zstd
, xorg

, withDefaultFeatures ? true
, additionalFeatures ? [ ]
}:
rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "0.99.0";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = version;
    hash = "sha256-X/+i4CSGAkNQ7oW1kbDUj/g6Hbrf17IXwpNPVmkE4tU=";
  };

  cargoHash = "sha256-6cGzEZdk0zgrRRTHlnlEqZg8AcoUi2GR3wZ3iq4WGKA=";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isLinux) [ python3 ];

  buildInputs = [ openssl zstd ]
    ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isLinux) [ xorg.libX11 ];

  buildNoDefaultFeatures = !withDefaultFeatures;
  buildFeatures = additionalFeatures;

  checkPhase = ''
    runHook preCheck
    (
      # The skipped tests all fail in the sandbox because in the nushell test playground,
      # the tmp $HOME is not set, so nu falls back to looking up the passwd dir of the build
      # user (/var/empty). The assertions however do respect the set $HOME.
      set -x
      HOME=$(mktemp -d) cargo test -j $NIX_BUILD_CORES --offline -- \
        --test-threads=$NIX_BUILD_CORES \
        --skip=repl::test_config_path::test_default_config_path \
        --skip=repl::test_config_path::test_xdg_config_bad \
        --skip=repl::test_config_path::test_xdg_config_empty
    )
    runHook postCheck
  '';

  passthru = {
    shellPath = "/bin/nu";
  };

  meta = with lib; {
    description = "Modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne johntitor joaquintrinanes ];
    mainProgram = "nu";
  };
}
