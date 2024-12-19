{ callPackage

, buildGo123Module
}:
callPackage ./generic.nix {
  version = "1.9.4";
  srcHash = "sha256-yhOyHfD5099dCY7lIJzTb8tQrqQ86N8HVtSk5mB7saY=";
  vendorHash = "sha256-Cxjgs4Hmv0sq11OpvYLnNcc76ojwqwcxMmCZT5Or0f4=";

  buildGoModule = buildGo123Module;
}
