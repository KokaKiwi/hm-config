{ config, pkgs, lib, ... }:
let
  cfg = config.programs.treefmt;
in {
  options.programs.treefmt = with lib; {
    enable = mkEnableOption "treefmt";

    package = mkPackageOption pkgs "treefmt" { };
  };

  config = with lib; mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
