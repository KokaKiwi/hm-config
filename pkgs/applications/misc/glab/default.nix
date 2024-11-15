{ lib, stdenv

, fetchFromGitLab
, installShellFiles

, buildGoModule
}:
buildGoModule rec {
  pname = "glab";
  version = "1.49.0";

  src = fetchFromGitLab {
    owner=  "gitlab-org";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-G9z9lISalj3ZXlvDY+qA+0NB6F7flBd1cTcGfxrM91U=";
  };

  vendorHash = "sha256-SsWZO77KqDPzyEK57WaK4NpnDWUtZPP0qur2EvEoiL0=";

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
