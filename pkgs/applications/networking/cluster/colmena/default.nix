{ lib

, fetchFromGitHub

, installShellFiles
, rustPlatform

, nix-eval-jobs
}:
rustPlatform.buildRustPackage {
  pname = "colmena";
  version = "0.4.0-unstable-2024-11-08";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "03f1a18a6fba9ad9c4edb1cc7cf394390c304198";
    hash = "sha256-N8gaV5bngMQPGyuo/RVdEsHTXvOeqjUhhxXpGea12DE=";
  };

  cargoHash = "sha256-RwZNQhfpU2yGg4Nz3Yc7NBb4Eg3LeFX+HQzBknCIAIk=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ nix-eval-jobs ];

  NIX_EVAL_JOBS = "${nix-eval-jobs}/bin/nix-eval-jobs";

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd colmena \
      --bash <($out/bin/colmena gen-completions bash) \
      --fish <($out/bin/colmena gen-completions fish) \
      --zsh <($out/bin/colmena gen-completions zsh)
  '';

  meta = with lib; {
    description = "A simple, stateless NixOS deployment tool";
    homepage = "https://github.com/zhaofengli/colmena";
    license = licenses.mit;
    mainProgram = "colmena";
  };
}
