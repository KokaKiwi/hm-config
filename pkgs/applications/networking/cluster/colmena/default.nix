{ lib

, fetchFromGitHub

, installShellFiles
, rustPlatform

, nix-eval-jobs
}:
rustPlatform.buildRustPackage {
  pname = "colmena";
  version = "0.4.0-unstable-2024-03-25";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "cd65ef7a25cdc75052fbd04b120aeb066c3881db";
    hash = "sha256-gWEpb8Hybnoqb4O4tmpohGZk6+aerAbJpywKcFIiMlg=";
  };

  cargoHash = "sha256-UhhPivsTkBEsDXJz64zatt2XS/D2YXZb6mf/B1+18eE=";

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
