{ callPackage }:
rec {
  version = callPackage ./version.nix {};
  inherit (version) gitVersion;
}
