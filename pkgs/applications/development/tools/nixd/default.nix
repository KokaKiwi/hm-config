{ lib, stdenv

, fetchFromGitHub

, meson
, ninja
, cmake
, python312
, pkg-config

, lit

, nix
, nixf
, nixt
, gtest
, boost182
, llvmPackages
, nlohmann_json
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nixd";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixd";
    rev = finalAttrs.version;
    hash = "sha256-5+ul4PxMgPkmGLB8CYpJcIcRDY/pJgByvjIHDA1Gs5A=";
  };

  mesonBuildType = "release";

  nativeBuildInputs = [
    meson
    ninja
    cmake
    python312
    pkg-config
  ];

  nativeCheckInputs = [
    lit
  ];

  buildInputs = [
    nix
    nixf
    nixt
    gtest
    boost182
    llvmPackages.llvm
    nlohmann_json
  ];

  env.CXXFLAGS = "-include ${nix.dev}/include/nix/config.h";

  env.NIX_CFLAGS_COMPILE = toString [
    "-O2" "-march=skylake"
  ];

  mesonFlags = [
    "-D" "b_lto=true"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Nix language server";
    homepage = "https://github.com/nix-community/nixd";
    changelog = "https://github.com/nix-community/nixd/releases/tag/${finalAttrs.version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ inclyc ];
    mainProgram = "nixd";
    platforms = platforms.unix;
  };
})
