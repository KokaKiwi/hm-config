{ pkgs, lib, ... }:
with lib;
let
  mapSyntax = mapAttrsToList (name: value: "${name}:${value}");
in {
  programs.bat = {
    package = pkgs.bat.override {
      rustPlatform = pkgs.fenixStableRustPlatform;
    };

    config = {
      italic-text = "always";
      paging = "always";
      style = concatStringsSep "," [
        "numbers"
        "changes"
        "header-filename"
        "header-filesize"
        "grid"
      ];
      pager = "${getExe pkgs.less} --RAW-CONTROL-CHARS --quit-if-one-screen";
      map-syntax = mapSyntax {
        ".ignore" = "Git Ignore";
      };
    };

    extraPackages = with pkgs.bat-extras; [
      (pkgs.wrapProgramBin "batdiff" {
        program = getExe batdiff;
        args = [
          "--set" "BATDIFF_USE_DELTA" "true"
        ];
      })
      batman
    ];
  };
}
