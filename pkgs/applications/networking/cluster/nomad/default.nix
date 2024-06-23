{ lib

, fetchFromGitHub
, installShellFiles

, buildGoModule
}:
buildGoModule rec {
  pname = "nomad";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    rev = "v${version}";
    hash = "sha256-twk3gCzGSl0gF2uPvarDuT4lWSWd9AV2PWUm2mBJpag=";
  };

  vendorHash = "sha256-sD3OboMQ5gJVz2+o0Rgpbco3YgibAOHUJUSiyxiG5OA=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';

  postInstall = ''
    echo "complete -C $out/bin/nomad nomad" > nomad.bash
    installShellCompletion nomad.bash
  '';

  meta = with lib; {
    homepage = "https://www.nomadproject.io/";
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    mainProgram = "nomad";
    license = licenses.bsl11;
  };
}
