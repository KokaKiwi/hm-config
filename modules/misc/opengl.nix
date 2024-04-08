{ pkgs, lib, ... }:
with lib;
{
  lib.opengl = {
    wrapPackage = drv: {
      exeName ? drv.meta.mainProgram or (getName drv),
      vadrivers ? [ pkgs.intel-media-driver ],
    }: let
      mesa-drivers = [ pkgs.mesa.drivers ];
      libvdpau = [ pkgs.libvdpau-va-gl ];

      libPaths = [
        (makeLibraryPath mesa-drivers)
        (makeSearchPathOutput "lib" "lib/vdpau" libvdpau)
        (makeLibraryPath [ pkgs.libglvnd ])
      ];
    in drv.overrideAttrs (super: let
      inherit (pkgs) makeWrapper;

      nativeBuildInputs' = super.nativeBuildInputs or [ ];
      nativeBuildInputs = if builtins.elem makeWrapper nativeBuildInputs'
        then nativeBuildInputs'
        else nativeBuildInputs' ++ [ makeWrapper ];
    in {
      inherit nativeBuildInputs;

      postInstall = (super.postInstall or "") + ''
        wrapProgram $out/bin/${exeName} \
          --prefix LD_LIBRARY_PATH ":" ${concatStringsSep ":" libPaths} \
          --prefix __EGL_VENDOR_LIBRARY_FILENAMES ":" ${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json \
          --set LIBGL_DRIVERS_PATH ${makeSearchPathOutput "lib" "lib/dri" mesa-drivers} \
          --set LIBVA_DRIVERS_PATH ${makeSearchPathOutput "out" "lib/dri" (mesa-drivers ++ vadrivers)}
      '';
    });
  };
}
