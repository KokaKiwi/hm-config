{ pkgs, super }:
{
  glfw3 = super.glfw3.overrideAttrs (super: with pkgs; {
    postPatch = ''
      substituteInPlace src/wl_init.c \
        --replace-fail "libxkbcommon.so.0" "${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0" \
        --replace-fail "libdecor-0.so.0" "${lib.getLib libdecor}/lib/libdecor-0.so.0" \
        --replace-fail "libwayland-client.so.0" "${lib.getLib wayland}/lib/libwayland-client.so.0" \
        --replace-fail "libwayland-cursor.so.0" "${lib.getLib wayland}/lib/libwayland-cursor.so.0" \
        --replace-fail "libwayland-egl.so.1" "${lib.getLib wayland}/lib/libwayland-egl.so.1"
    '';
  });

  trashy = super.trashy.overrideAttrs {
    postInstall = ''
      $out/bin/trash manpage > trash.1
      installManPage trash.1
    '';
  };
}
