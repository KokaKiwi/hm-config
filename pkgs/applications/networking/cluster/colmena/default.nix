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
    rev = "c4d72269affff3abbe7175d363e6c0edf1b0e167";
    hash = "sha256-n1UeNT2PrbOlLNa+EhFMrniUN4BtGqCw9R9/qWpzNEA=";
  };

  cargoHash = "sha256-McqaSVgy2aEotxXaFB2BB/1lWwoU5OmWr/cUX0wyY2Y=";

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
