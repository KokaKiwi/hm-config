{ lib, stdenv

, fetchFromGitHub

, cmake
, rustPlatform
, cargo, rustc
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wasmtime-c-api";
  version = "26.0.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-jGe8HXiXG4/UxpxWjBBwGJjUSyC69jSizaxxU3OILy8=";
  };

  nativeBuildInputs = [
    cmake

    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-enJ6XhtrbS5fYBnWMxW1dkyqxPIK4aRuq5E8fQnNroc=";
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
