{ lib

, fetchFromGitHub
, installShellFiles

, buildGoModule
}:
buildGoModule rec {
  pname = "nomad";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    rev = "v${version}";
    hash = "sha256-BzLvALD65VqWNB9gx4BgI/mYWLNeHzp6WSXD/1Xf0Wk=";
  };

  vendorHash = "sha256-0mnhZeiCLAWvwAoNBJtwss85vhYCrf/5I1AhyXTFnWk=";

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
