{ lib, stdenv

, fetchFromGitHub

, rustPlatform
, installShellFiles

, darwin
, curl
}:
rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.28.0-unstable-2024-10-01";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "0407fad8960a89a3fcfaa9619041a4ad470c2838";
    hash = "sha256-8UF3bLXvOwZxSPZl0vrEhmondnmMQSgWFGea6WyVMzA=";
  };

  cargoHash = "sha256-iBQMWQ3xAPu4AaylnU+ZjvwLVh8D6Ejsvp7LuC6zOeg=";

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
