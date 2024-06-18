{ pkgs, super }:
{
  glfw3 = super.glfw3.overrideAttrs (super: {
    postPatch = super.postPatch + ''
    substituteInPlace src/wl_init.c \
      --replace-warn "libdecor-0.so.0" "${pkgs.lib.getLib pkgs.libdecor}/lib/libdecor-0.so.0" \
      --replace-warn "libwayland-client.so.0" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-client.so.0" \
      --replace-warn "libwayland-cursor.so.0" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-cursor.so.0" \
      --replace-warn "libwayland-egl.so.1" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-egl.so.1"
    '';
  });

  go_1_22 = super.go_1_22.overrideAttrs (prev: rec {
    version = "1.22.4";
    src = pkgs.fetchurl {
      url = "https://go.dev/dl/go${version}.src.tar.gz";
      hash = "sha256-/tcgZ45yinyjC6jR3tHKr+J9FgKPqwIyuLqOIgCPt4Q=";
    };
  });

  trashy = super.trashy.overrideAttrs {
    postInstall = ''
      $out/bin/trash manpage > trash.1
      installManPage trash.1
    '';
  };
}
