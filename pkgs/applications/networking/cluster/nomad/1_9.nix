{ callPackage

, buildGo123Module
}:
callPackage ./generic.nix {
  version = "1.9.1";
  srcHash = "sha256-kqOlIRKaYr4nHxWfviPRvJRq+vsMH7InYdlD99Il4+Q=";
  vendorHash = "sha256-Ss/qwQ14VUu40nXaIgTfNuj95ekTTVrY+zcStFDSCyI=";

  buildGoModule = buildGo123Module;
}
