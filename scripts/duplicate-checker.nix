{ pkgs, lib, sources, ... }:
let
  nixpkgs = import sources.nixpkgs { };
  localpkgs = import ../pkgs {
    inherit pkgs;
    super = nixpkgs;
    inherit sources;
  };

  duplicates = let
    packages = lib.filterAttrs (name: drv: let
      orig = nixpkgs.${name} or null;
    in orig != null && orig.version == drv.version) localpkgs;
  in builtins.attrValues packages;
in pkgs.writeShellScript "duplicated-checker" ''
  ${lib.concatMapStringsSep "\n" (drv: "echo ${drv.pname} ${drv.version}") duplicates}
''
