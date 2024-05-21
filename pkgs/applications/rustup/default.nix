{ lib, stdenv

, fetchFromGitHub

, installShellFiles
, makeBinaryWrapper
, patchelf
, rustPlatform
, substituteAll

, pkg-config
, openssl
, curl
, zlib
}:
let
  libPath = lib.makeLibraryPath [
    zlib # libz.so.1
  ];

  binaries = [
    "cargo" "rustc" "rustdoc" "rust-gdb" "rust-lldb" "rls"
    "rustfmt" "cargo-fmt" "cargo-clippy" "clippy-driver" "cargo-miri"
    "rust-gdbgui" "rust-analyzer"
  ];
in rustPlatform.buildRustPackage rec {
  pname = "rustup";
  version = "1.27.1";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustup";
    rev = version;
    sha256 = "sha256-BehkJTEIbZHaM+ABaWN/grl9pX75lPqyBj1q1Kt273M=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  patches = [
    (substituteAll {
      src = ./0001-dynamically-patchelf-binaries.patch;

      patchelf = toString patchelf;
      libPath = "$ORIGIN/../lib:${libPath}";
      dynamicLinker = lib.pipe "${stdenv.cc}/nix-support/dynamic-linker" [
        builtins.readFile
        (lib.removeSuffix "\n")
      ];
    })
  ];

  nativeBuildInputs = [
    installShellFiles makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    (curl.override { inherit openssl; })
    zlib
  ];

  buildFeatures = [ "no-self-update" ];

  doCheck = false;

  postInstall = ''
    mv $out/bin/{rustup-init,rustup}

    for link in ${lib.concatStringsSep " " binaries}; do
      ln -s rustup $out/bin/$link
    done

    wrapProgram $out/bin/rustup \
      --prefix "LD_LIBRARY_PATH" : "${libPath}"

    # tries to create .rustup
    export HOME=$(mktemp -d)

    installShellCompletion --cmd rustup \
      --bash <($out/bin/rustup completions bash rustup) \
      --fish <($out/bin/rustup completions fish rustup) \
      --zsh <($out/bin/rustup completions zsh rustup)

    # TODO: fish completion not yet supported for cargo
    installShellCompletion --cmd cargo \
      --bash <($out/bin/rustup completions bash cargo) \
      --zsh <($out/bin/rustup completions zsh cargo)
  '';

  meta = with lib; {
    description = "The Rust toolchain installer";
    homepage = "https://www.rustup.rs/";
    license = with licenses; [ asl20 /* or */ mit ];
  };
}
