{ lib, stdenv

, fetchFromGitLab
, installShellFiles

, buildGoModule
}:
buildGoModule rec {
  pname = "glab";
  version = "1.45.0";

  src = fetchFromGitLab {
    owner=  "gitlab-org";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-jTpddpS+FYSQg2aRxQiVlG+bitiIqmZ4kxOJLPZkICo=";
  };

  vendorHash = "sha256-o0sYObTeDgG+3X3YEnDbk1h4DkEiMwEgYMF7hGjCL3Q=";

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "cmd/glab" ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    make manpage
    installManPage share/man/man1/*

    installShellCompletion --cmd glab \
      --bash <($out/bin/glab completion -s bash) \
      --fish <($out/bin/glab completion -s fish) \
      --zsh <($out/bin/glab completion -s zsh)
  '';

  meta = {
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/gitlab-org/cli";
    changelog = "https://gitlab.com/gitlab-org/cli/-/releases/v${version}";
    mainProgram = "glab";
  };
}
