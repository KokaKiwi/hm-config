{ lib

, fetchFromGitHub

, installShellFiles
, rustPlatform

, nix-eval-jobs
}:
rustPlatform.buildRustPackage {
  pname = "colmena";
  version = "0.4.0-unstable-2024-11-13";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "e3ad42138015fcdf2524518dd564a13145c72ea1";
    hash = "sha256-dI9I6suECoIAmbS4xcrqF8r2pbmed8WWm5LIF1yWPw8=";
  };

  cargoHash = "sha256-xM2/2VuQsJBCjrjcuzHiqWQc/NoOiD/6nAhiobP/0oQ=";

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
