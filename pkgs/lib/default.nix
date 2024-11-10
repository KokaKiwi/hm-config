{ callPackage }:
rec {
  versionTools = callPackage ./version.nix {};
  inherit (versionTools) gitVersion;
}
