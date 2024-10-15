{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;

    package = pkgs.nushell.override {
      python3 = pkgs.python312;
      inherit (pkgs.rustTools.rust_1_81) rustPlatform;

      additionalFeatures = [
        "system-clipboard"
      ];
    };
  };
}
