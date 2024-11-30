{ lib, stdenv

, fetchCrate

, rustPlatform

, pkg-config

, curl
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
  version = "0.10.7";

  src = fetchCrate {
    inherit pname;
    # this version may need to be updated along with package version
    version = "${version}+cargo-0.84.0";
    hash = "sha256-rUyFvEkzJgfnCQ9DikLCTDd83lnYJzMxpQH/iiWYa3M=";
  };

  cargoHash = "sha256-bwgjtXYSx0QBv0TtW6uyoIPopGUwrDRVJzCQPcKYXz0=";

  nativeBuildInputs = [ pkg-config (lib.getDev curl) ];
  buildInputs = [ openssl curl ];

  # Ensure that we are avoiding build of the curl vendored in curl-sys
  doInstallCheck = stdenv.hostPlatform.libc == "glibc";
  installCheckPhase = ''
    runHook preInstallCheck

    ldd "$out/bin/cargo-cbuild" | grep libcurl.so

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Cargo subcommand to build and install C-ABI compatible dynamic and static libraries";
    longDescription = ''
      Cargo C-ABI helpers. A cargo applet that produces and installs a correct
      pkg-config file, a static library and a dynamic library, and a C header
      to be used by any C (and C-compatible) software.
    '';
    homepage = "https://github.com/lu-zero/cargo-c";
    changelog = "https://github.com/lu-zero/cargo-c/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cpu ];
  };
}
