{ lib, stdenv

, fetchFromGitLab
, installShellFiles

, buildGoModule
}:
buildGoModule rec {
  pname = "glab";
  version = "1.47.0";

  src = fetchFromGitLab {
    owner=  "gitlab-org";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-mAM11nQ6YJJWNFOR9xQbgma7Plvo4MdcW2Syniw7o60=";
  };

  vendorHash = "sha256-uwSVdebZtIpSol553gJC0ItkEqa6qXXOAVFvzjsHSSI=";

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
