{ lib

, fetchFromGitHub
, installShellFiles

, buildGoModule
}:
buildGoModule rec {
  pname = "nomad";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    rev = "v${version}";
    hash = "sha256-deVLC7yGgLHCauq+3h0Uu5ln5omoeV8/FkVtQM9CEXc=";
  };

  vendorHash = "sha256-Pr38tRzym8UFPZKs9367xOZJ9P5OHotwwClorcSgOys=";

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
