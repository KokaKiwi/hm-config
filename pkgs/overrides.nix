{ pkgs, super }:
{
  git-interactive-rebase-tool = (super.git-interactive-rebase-tool.override {
    rustPlatform = pkgs.fenixStableRustPlatform;
  }).overrideAttrs (prev: {
    postPatch = prev.postPatch + ''
      substituteInPlace src/main.rs src/{config,core,display,input,git,runtime,todo_file,testutils,view}/src/lib.rs \
        --replace-warn "warnings" ""
    '';
  });

  glfw3 = super.glfw3.overrideAttrs (super: {
    postPatch = super.postPatch + ''
    substituteInPlace src/wl_init.c \
      --replace-warn "libdecor-0.so.0" "${pkgs.lib.getLib pkgs.libdecor}/lib/libdecor-0.so.0" \
      --replace-warn "libwayland-client.so.0" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-client.so.0" \
      --replace-warn "libwayland-cursor.so.0" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-cursor.so.0" \
      --replace-warn "libwayland-egl.so.1" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-egl.so.1"
    '';
  });

  trashy = super.trashy.overrideAttrs {
    postInstall = ''
      $out/bin/trash manpage > trash.1
      installManPage trash.1
    '';
  };
}
