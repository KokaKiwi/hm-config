{ lib

, fetchFromGitHub

, rustPlatform
, installShellFiles
}:
rustPlatform.buildRustPackage rec {
  pname = "dust";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    hash = "sha256-ERcXVLzgurY6vU+exZ5IcM0rPbWrpghDO1m2XwE5i38=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoHash = "sha256-ZYv3TECIRHZgEOItKCsiLFejTVeKl/NtptXAhgpQgZE=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = ''
    installManPage man-page/dust.1
    installShellCompletion completions/dust.{bash,fish} --zsh completions/_dust
  '';

  meta = with lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "dust";
  };
}
