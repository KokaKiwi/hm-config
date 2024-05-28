{ lib, stdenv

, fetchFromGitLab
, installShellFiles

, buildGoModule
}:
buildGoModule rec {
  pname = "glab";
  version = "1.41.0";

  src = fetchFromGitLab {
    owner=  "gitlab-org";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-DvIp7eMBWKWQ5VW9MW391xnUz8o1KNz1mkJtu7YVILo=";
  };

  vendorHash = "sha256-WM19Kx2b31e4/iA92U9FUuF8R1DMvbKotE2D9HpLQpQ=";

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
