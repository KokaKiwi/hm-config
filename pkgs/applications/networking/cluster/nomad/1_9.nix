{ callPackage

, buildGo123Module
}:
callPackage ./generic.nix {
  version = "1.9.2";
  srcHash = "sha256-HIyRzujAGwhB2anbxidhq5UpWYHkigyyHfxIUwMF5X8=";
  vendorHash = "sha256-YIOTdD+oRDdEHkBzQCUuKCz7Wbj4mFjrZY0J3Cte400=";

  buildGoModule = buildGo123Module;
}
