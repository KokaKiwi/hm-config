{ pkgs, super }:
let
  fixRustPackage = drv: drv.override {
    inherit (pkgs.rustTools.rust_1_79) rustPlatform;
  };
in {
  # Fixed packages
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

  cargo-audit = fixRustPackage super.cargo-audit;
  cargo-outdated = fixRustPackage super.cargo-outdated;
  silicon = fixRustPackage super.silicon;

  # Udated packages
  bun = super.bun.overrideAttrs (self: prev: {
    version = "1.1.26";

    buildInputs = [ ];

    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${self.version}/bun-linux-x64.zip";
      hash = "sha256-qHBNhvZRTjBEmDOsMJRIz4TgiLbtuWjgVHfP+aBaqio=";
    };
  });
}
