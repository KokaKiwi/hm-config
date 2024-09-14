{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.sccache;
in {
  options.programs.sccache = {
    enable = mkEnableOption "sccache";

    package = mkPackageOption pkgs "sccache" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
