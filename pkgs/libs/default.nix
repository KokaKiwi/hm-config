{ pkgs }:
let
  inherit (pkgs) kiwiPackages;

  callPackage = kiwiPackages.callPackageIfNewer;
in {
  cpp-utilities = callPackage ./cpp-utilities { };
}
