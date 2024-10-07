{ lib

, fetchFromGitHub

, installShellFiles
, rustPlatform

, nix-eval-jobs
}:
rustPlatform.buildRustPackage {
  pname = "colmena";
  version = "0.4.0-unstable-2024-10-07";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "b0a62f234fae02a006123e661ff70e62af16106b";
    hash = "sha256-gyUVsPAWY9AgVKjrNPoowrIr5BvK4gI0UkDXvv8iSxA=";
  };

  cargoHash = "sha256-M+ofKLx7G9n9bgwht5uZYwURddwq1m6816KqskhDWcA=";

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
