{ lib

, fetchFromGitHub
, installShellFiles

, buildGoModule
}:
buildGoModule rec {
  pname = "nomad";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    rev = "v${version}";
    hash = "sha256-u1R5lG9fpIbAePLlDy+kk2hQpFdT1VIY0sMskHJZ19w=";
  };

  vendorHash = "sha256-5Gn37hFVDkUlyv4MVZMH9PlpyWAyWE5RTFQyuMIA/Bc=";

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
