{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.glab;
in {
  options.programs.glab = {
    enable = mkEnableOption "glab";

    package = mkPackageOption pkgs "glab" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
