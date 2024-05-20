{ lib, callPackage

, fetchFromGitHub

, cmake
, gettext
, lua
, removeReferencesTo
, llvmPackages

, libuv
, libvterm-neovim
, msgpack-c
, unibilium
}: let
  stdenv = llvmPackages.stdenv.override (super: {
    cc = super.cc.override {
      inherit (llvmPackages) bintools;
    };
  });

  requiredLuaPackages = ps: (with ps; [
    lpeg
  ]);
  luaEnv = lua.withPackages requiredLuaPackages;
  luaEnvOnBuild = lua.luaOnBuild.withPackages requiredLuaPackages;

  codegenLua = if lua.luaOnBuild.pkgs.isLuaJIT
    then let
      deterministicLuajit = lua.luaOnBuild.override {};
    in deterministicLuajit
    else lua.luaOnBuild;

  tree-sitter = callPackage ./deps/tree-sitter.nix { };
in stdenv.mkDerivation (final: {
  pname = "neovim";
  version = "nightly-unstable-2024-05-20";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "36a9da65472f1607568c9be9b91c06357e39fce4";
    hash = "sha256-4hMvqOfqfMT3YegpQkxU7WOPy5qE/Szc7v2YaE5SOis=";
  };

  NIX_CFLAGS_COMPILE = toString [
    "-O2" "-march=x86-64-v3"
    "-flto=full"
  ];

  nativeBuildInputs = [
    cmake
    gettext
    removeReferencesTo
  ];

  buildInputs = [
    luaEnv
    lua.pkgs.libluv
    libuv
    libvterm-neovim
    msgpack-c
    unibilium
    tree-sitter
  ];

  postPatch = ''
    substituteInPlace src/nvim/version.c --replace NVIM_VERSION_CFLAGS ""
  '';

  dontFixCmake = true;
  cmakeFlagsArray = [
    "-DUSE_BUNDLED=OFF"
  ]
  ++ lib.optional (!lua.pkgs.isLuaJIT) "-DPREFER_LUA=ON"
  ++ lib.optionals lua.pkgs.isLuaJIT [
    "-DLUAC_PRG=${codegenLua}/bin/luajit -b -s %s -"
    "-DLUA_GEN_PRG=${codegenLua}/bin/luajit"
    "-DLUA_PRG=${luaEnvOnBuild}/bin/luajit"
  ];

  postInstall = ''
    find "$out" -type f -exec remove-references-to -t ${stdenv.cc} '{}' +
  '';

  separateDebugInfo = true;
  enableParallelBuilding = true;

  meta = {
    description = "Vim text editor fork focused on extensibility and agility";
    longDescription = ''
      Neovim is a project that seeks to aggressively refactor Vim in order to:
      - Simplify maintenance and encourage contributions
      - Split the work between multiple developers
      - Enable the implementation of new/modern user interfaces without any
        modifications to the core source
      - Improve extensibility with a new plugin architecture
    '';
    homepage = "https://www.neovim.io";
    mainProgram = "nvim";
    license = with lib.licenses; [ asl20 vim ];
    platforms = lib.platforms.unix;
  };
})
