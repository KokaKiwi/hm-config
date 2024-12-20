{ pkgs, super, sources }:
let
  opkgs = import sources.nixpkgs {};
in {
  # Fixup deps
  webkitgtk_4_0 = super.webkitgtk_4_0.override {
    inherit (opkgs) geoclue2;
  };
  webkitgtk_4_1 = super.webkitgtk_4_1.override {
    inherit (opkgs) geoclue2;
  };
  webkitgtk_6_0 = super.webkitgtk_6_0.override {
    inherit (opkgs) geoclue2;
  };

  nixt = super.nixt.override {
    nix = pkgs.nixVersions.stable_upstream;
  };

  # Udated packages
  bun = super.bun.overrideAttrs (self: prev: {
    version = "1.1.42";

    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${self.version}/bun-linux-x64.zip";
      hash = "sha256-NoIGwwONj6q8Y+MFnu6mTCr5xQ7Q37+4b2SYS6adsa8=";
    };
  });
}
