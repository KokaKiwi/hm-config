{ lib, fetchzip }:
let
  version = "2.91.0";
in {
  lix = fetchzip {
    name = "lix-source";
    url = "https://git.lix.systems/lix-project/lix/archive/${version}.tar.gz";
    hash = "sha256-Rosl9iA9MybF5Bud4BTAQ9adbY81aGmPfV8dDBGl34s=";
  };
  nixos-module = fetchzip {
    name = "lix-nixos-module-source";
    url = "https://git.lix.systems/lix-project/nixos-module/archive/${version}.tar.gz";
    hash = "sha256-zNW/rqNJwhq2lYmQf19wJerRuNimjhxHKmzrWWFJYts=";
  };
}
