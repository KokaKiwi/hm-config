{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.password-store;
in {
  home.packages = mkIf cfg.enable (with pkgs; [
    docker-credential-helpers
  ]);

  programs.password-store = {
    package = pkgs.pass.withExtensions (exts: with exts; [
      pass-otp
    ]);
  };
}
