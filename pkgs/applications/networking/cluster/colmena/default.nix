{ lib

, fetchFromGitHub

, installShellFiles
, rustPlatform

, nix-eval-jobs
}:
rustPlatform.buildRustPackage {
  pname = "colmena";
  version = "0.4.0-unstable-2024-11-10";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "a2193487bcf70bbb998ad1a25a4ff02b8d55db7a";
    hash = "sha256-04iOZoJ0D+y3xhZtaCgSBOz8T4hED7oMVkuAOzXT8vU=";
  };

  cargoHash = "sha256-cuZu1DTodIOgcQ3Wb1m3ECNyZnzrPtcFOljVQjGodGY=";

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
