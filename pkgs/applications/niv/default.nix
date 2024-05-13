{ lib, mkDerivation

, fetchFromGitHub

, aeson, aeson-pretty, ansi-terminal, base
, bytestring, directory, file-embed, filepath, hashable
, hpack, http-conduit, mtl, optparse-applicative, process
, profunctors, pureMD5, string-qq, tasty, tasty-hunit, text
, unliftio, unordered-containers
}:
mkDerivation {
  pname = "niv";
  version = "0.2.22-unstable-2024-05-13";

  src = fetchFromGitHub {
    owner = "nmattia";
    repo = "niv";
    rev = "04c1cec14801d2b18fc1a771cf40cec249cb8670";
    hash = "sha256-ISiTGJYiSr5LTobm5+wtXE7+RnFgPj8wjzx9RaKthPY=";
  };

  isLibrary = true;
  isExecutable = true;

  enableSeparateBinOutput = true;

  libraryHaskellDepends = [
    aeson aeson-pretty ansi-terminal base bytestring directory
    file-embed filepath hashable http-conduit mtl optparse-applicative
    process profunctors pureMD5 string-qq tasty tasty-hunit text
    unliftio unordered-containers
  ];

  libraryToolDepends = [ hpack ];

  executableHaskellDepends = [
    aeson aeson-pretty ansi-terminal base bytestring directory
    file-embed filepath hashable http-conduit mtl optparse-applicative
    process profunctors pureMD5 string-qq text unliftio
    unordered-containers
  ];

  testHaskellDepends = [
    aeson aeson-pretty ansi-terminal base bytestring directory
    file-embed filepath hashable http-conduit mtl optparse-applicative
    process profunctors pureMD5 string-qq tasty text unliftio
    unordered-containers
  ];

  prePatch = "hpack";

  homepage = "https://github.com/nmattia/niv#readme";
  description = "Easy dependency management for Nix projects";
  license = lib.licenses.mit;
  mainProgram = "niv";
}
