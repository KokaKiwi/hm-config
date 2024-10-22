{ lib, stdenv

, fetchFromGitHub

, cmake
, rustPlatform
, cargo, rustc
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wasmtime-c-api";
  version = "26.0.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-n9niZU+nmxDJXFLx4LZAKFDeB9KIe7DxBI+JpXZTE7w=";
  };

  nativeBuildInputs = [
    cmake

    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-R2HIe8FDXIrXdPoyV8NR14jrKogrSz6ylNp8iV6b674=";
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
