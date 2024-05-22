{ config, pkgs, lib, ... }:
with lib;
let
  inherit (config.lib) opengl;

  imhex = opengl.wrapPackage (pkgs.imhex.override {
    llvm = pkgs.llvm_18;
    python3 = pkgs.python312;
  });
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
