{ config, pkgs, ... }:
let
  inherit (config.lib) opengl;

  imhex = let
    package = pkgs.nur.repos.kokakiwi.imhex.override {
      llvm = pkgs.llvm_18;
      python3 = pkgs.python312;
    };
  in opengl.wrapPackage package;
in {
  home.packages = [ imhex ];

  xdg.localDesktopEntries.imhex = {
    name = "ImHex";
    comment = "ImHex Hex Editor";
    genericName = "Hex Editor";
    exec = "${imhex}/bin/imhex %U";
    icon = "imhex";
    startupNotify = true;
    startupWMClass = "imhex";
    categories = [ "Development" "IDE" ];
  };
}
