{ lib
, fetchFromGitHub

, installShellFiles
, rustPlatform

, pkg-config
, oniguruma

, git
}:
rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    hash = "sha256-1UOVRAceZ4QlwrHWqN7YI2bMyuhwLnxJWpfyaHNNLYg=";
  };

  cargoHash = "sha256-/h7djtaTm799gjNrC6vKulwwuvrTHjlsEXbK2lDH+rc=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  nativeCheckInputs = [ git ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = ''
    installShellCompletion --cmd delta \
      etc/completion/completion.{bash,fish,zsh}
  '';

  # test_env_parsing_with_pager_set_to_bat sets environment variables,
  # which can be flaky with multiple threads:
  # https://github.com/dandavison/delta/issues/1660
  dontUseCargoParallelTests = true;

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "Syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq SuperSandro2000 figsoda ];
    mainProgram = "delta";
  };
}