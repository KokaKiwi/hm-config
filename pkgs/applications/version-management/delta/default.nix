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
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    hash = "sha256-9hi3efHzJV9jKJPSkyBaRO7hCYT17QPhw9pP/GwkMdo=";
  };

  cargoHash = "sha256-aQaqQApoPlm/VhGs11RI9+Fk8s2czuJbOreSr3fEX+g=";

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
