{ lib, stdenv

, fetchFromGitHub

, rustPlatform
, installShellFiles

, darwin
, curl
}:
rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.28.0-unstable-2024-09-12";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "8876500f3caa42b21771576367bf5426782da104";
    hash = "sha256-jrQnmIYap5eHVWPqoRsXVroB0VWLKxesi3rB/WylR0U=";
  };

  cargoHash = "sha256-O6TlUCjUnqiJY1BabXOOAMotlDlvzJyhQvp1dsPT+2s=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Security
    SystemConfiguration
  ]);

  nativeCheckInputs = [
    curl
  ];

  checkFlags = [
    "--skip=bind_ipv4_ipv6::case_2"
    "--skip=qrcode_hidden_in_tty_when_disabled"
    "--skip=qrcode_shown_in_tty_when_enabled"
    "--skip=show_root_readme_contents"
    "--skip=validate_printed_urls"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/miniserve --print-manpage >miniserve.1
    installManPage miniserve.1

    installShellCompletion --cmd miniserve \
      --bash <($out/bin/miniserve --print-completions bash) \
      --fish <($out/bin/miniserve --print-completions fish) \
      --zsh <($out/bin/miniserve --print-completions zsh)
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "CLI tool to serve files and directories over HTTP";
    homepage = "https://github.com/svenstaro/miniserve";
    changelog = "https://github.com/svenstaro/miniserve/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "miniserve";
  };
}
