{ callPackage

, buildGo123Module
}:
callPackage ./generic.nix {
  version = "1.9.3";
  srcHash = "sha256-KjVr9NIL9Qw10EoP/C+2rjtqU2qBSF6SKpIvQWQJWuo=";
  vendorHash = "sha256-paUI5mYa9AvMsI0f/VeVdnZzwKS9gsBIb6T4KmugPKQ=";

  buildGoModule = buildGo123Module;
}
