{ lib, stdenv

, fetchFromGitHub

, cmake
, rustPlatform
, cargo, rustc
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wasmtime-c-api";
  version = "28.0.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-ygdrXDOlcskL6bALP3n+9Bw9WRqDeDoCu5u5GZ6+eNQ=";
  };

  nativeBuildInputs = [
    cmake

    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-Nzry72kp8fC38xdoxuocJ0JdlgQM5FniJIDWj18W064=";
  };

  cmakeDir = "../crates/c-api";

  meta = with lib; {
    description =
      "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://wasmtime.dev/";
    changelog = "https://github.com/bytecodealliance/wasmtime/blob/v${finalAttrs.version}/RELEASES.md";
    license = licenses.asl20;
    mainProgram = "wasmtime";
    platforms = platforms.unix;
  };
})
