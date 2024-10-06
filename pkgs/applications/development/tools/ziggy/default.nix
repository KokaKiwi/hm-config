{ lib, stdenv
, callPackage

, fetchFromGitHub
, writeShellScript

, zig
, zon2nix
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ziggy";
  version = "0.0.1-unstable-2024-09-14";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "ziggy";
    rev = "42b6f5d7320340bc5903c4c29d34065e8517a549";
    hash = "sha256-08y6Km7tO9YhJBmWXvPVjiku1QRRNcmJ2h2EbMa6Q/g=";
  };

  deps = callPackage ./deps.nix { };

  postPatch = ''
    ln -s $deps $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    zig.hook
  ];

  passthru = {
    update-deps = writeShellScript "update-deps" ''
      ${lib.getExe zon2nix} ${finalAttrs.src} > ${toString ./deps.nix}
    '';
  };

  meta = with lib; {
    description = "A data serialization language for expressing clear API messages, config files, etc";
    homepage = "https://github.com/kristoff-it/ziggy";
    license = licenses.mit;
    mainProgram = "ziggy";
    inherit (zig.meta) platforms;
  };
})
