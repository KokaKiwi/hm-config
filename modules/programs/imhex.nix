{ config, pkgs, lib, ... }:
with lib;
let
  imhex = let
    patchedImhex = pkgs.imhex.overrideAttrs {
      patches = [
        ../../patches/imhex.patch
      ];
    };
    imhex = patchedImhex.override {
      llvm = pkgs.llvm_18;
      python3 = pkgs.python312;
      glfw3 = pkgs.glfw3.overrideAttrs (super: {
        postPatch = super.postPatch + ''
          substituteInPlace src/wl_init.c \
            --replace "libdecor-0.so.0" "${lib.getLib pkgs.libdecor}/lib/libdecor-0.so.0"

          substituteInPlace src/wl_init.c \
            --replace "libwayland-client.so.0" "${lib.getLib pkgs.wayland}/lib/libwayland-client.so.0"

          substituteInPlace src/wl_init.c \
            --replace "libwayland-cursor.so.0" "${lib.getLib pkgs.wayland}/lib/libwayland-cursor.so.0"

          substituteInPlace src/wl_init.c \
            --replace "libwayland-egl.so.1" "${lib.getLib pkgs.wayland}/lib/libwayland-egl.so.1"
        '';
      });
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
