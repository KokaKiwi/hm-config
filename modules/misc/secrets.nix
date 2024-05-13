{ config, pkgs, lib, sources, ... }:
with lib;
let
  entries = import ../../secrets/secrets.nix;
  secrets = mapAttrs' (name: { path ? null, ... }@entry:
    let
      name' = removeSuffix ".age" name;
      entry' = removeAttrs entry [ "publicKeys" "path" ];
      path' = if builtins.isFunction path
        then entry.path config
        else entry.path;
    in nameValuePair name' (entry' // {
      file = lib.path.append ../../secrets name;
      path = mkIf (path != null) path';
    })) entries;
in {
  imports = [
    "${sources.agenix}/modules/age-home.nix"
  ];

  home.packages = with pkgs; [ agenix ];

  age.package = pkgs.rage;

  age.identityPaths = [
    "${config.xdg.dataHome}/rage/kira.key"
  ];

  age.secrets = secrets;

  _module.args = {
    secrets = config.age.secrets;
  };
}
