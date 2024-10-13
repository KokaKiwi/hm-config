{ lib

, fetchFromGitHub
, rustPlatform

, installShellFiles

, pkg-config
, withNativeTls ? true, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "xh";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "ducaale";
    repo = "xh";
    rev = "v${version}";
    sha256 = "sha256-rHhL2IWir+DpbNFu2KddslmhhiSpkpU633JYFYCoWvY=";
  };

  cargoHash = "sha256-5V27ZV+5jWFoGMFe5EXmLdX2BjPuWDMdn4DK54ZIfUY=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = lib.optionals withNativeTls [ openssl ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "rustls" ]
    ++ lib.optional withNativeTls "native-tls";

  # Get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR = 1;

  postInstall = ''
    installShellCompletion \
      completions/xh.{bash,fish} \
      --zsh completions/_xh

    installManPage doc/xh.1
    ln -s $out/share/man/man1/xh.1 $out/share/man/man1/xhs.1

    install -m444 -Dt $out/share/doc/xh README.md CHANGELOG.md

    ln -s $out/bin/xh $out/bin/xhs
  '';

  checkFlags = let
    skippedTests = [
      "cases::logging::checked_status_is_printed_with_single_quiet"
      "cases::logging::warning_for_invalid_redirect"
      "cases::logging::warning_for_non_utf8_redirect"
      "check_status_warning"
      "nested_json_type_error"
      "unsupported_tls_version_rustls"

      # ???
      "warn_for_filename_tag_on_body"
    ];
  in lib.map (test: "--skip=${test}") skippedTests;

  postInstallCheck = ''
    $out/bin/xh --help > /dev/null
    $out/bin/xhs --help > /dev/null
  '';

  meta = with lib; {
    description = "Friendly and fast tool for sending HTTP requests";
    homepage = "https://github.com/ducaale/xh";
    changelog = "https://github.com/ducaale/xh/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda bhankas ];
  };
}
