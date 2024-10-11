{ callPackage

, buildGo123Module
}:
callPackage ./generic.nix {
  version = "1.9.0";
  srcHash = "sha256-MJNPYSH3KsRmGQeOcWw4VvDeFGinfsyGSo4q3OdOZo8=";
  vendorHash = "sha256-Ss/qwQ14VUu40nXaIgTfNuj95ekTTVrY+zcStFDSCyI=";

  buildGoModule = buildGo123Module;
}
