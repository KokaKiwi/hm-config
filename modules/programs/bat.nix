{ pkgs, lib, ... }:
let
  mapSyntax = lib.mapAttrsToList (name: value: "${name}:${value}");

  batdiff = pkgs.bat-extras.batdiff.overrideAttrs (super: {
    doCheck = false;
  });
in {
  programs.bat = {
    enable = true;
    package = pkgs.bat.override {
      rustPlatform = pkgs.fenixStableRustPlatform;
    };

    config = {
      italic-text = "always";
      paging = "always";
      style = lib.concatStringsSep "," [
        "numbers"
        "changes"
        "header-filename"
        "header-filesize"
        "grid"
      ];
      pager = "${lib.getExe pkgs.less} --RAW-CONTROL-CHARS --quit-if-one-screen";
      map-syntax = mapSyntax {
        ".ignore" = "Git Ignore";
      };
    };

    extraPackages = with pkgs.bat-extras; [
      (pkgs.wrapProgramBin "batdiff" {
        program = "${batdiff}/bin/batdiff";
        args = [
          "--set" "BATDIFF_USE_DELTA" "true"
        ];
      })
      batman
    ];
  };
}
