{ lib, stdenv

, fetchFromGitHub

, cmake
, rustPlatform
, cargo, rustc
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wasmtime-c-api";
  version = "27.0.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-uM5MVCl+v9IzgZPC0J3hpT1/Erox8S1CkY1ExIOiHSA=";
  };

  nativeBuildInputs = [
    cmake

    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-mHlDnv1MCeexOi1+SWO1XOJHpiRd/ElRWYzRauJX1Fc=";
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
