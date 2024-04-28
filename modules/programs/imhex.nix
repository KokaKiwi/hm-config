{ config, pkgs, lib, ... }:
with lib;
let
  imhex = let
    patchedImhex = pkgs.imhex.overrideAttrs {
      patches = [
        ../../patches/imhex.patch
      ];

      meta.mainProgram = "imhex";
    };
    imhex = patchedImhex.override {
      llvm = pkgs.llvm_18;
      python3 = pkgs.python312;
    };
  in config.lib.opengl.wrapPackage imhex { };
in {
  home.packages = [ imhex ];

  xdg.localDesktopEntries.imhex = {
    name = "ImHex";
    comment = "ImHex Hex Editor";
    genericName = "Hex Editor";
    exec = "${getExe imhex} %U";
    icon = "imhex";
    startupNotify = true;
    startupWMClass = "imhex";
    categories = [ "Development" "IDE" ];
  };
}
