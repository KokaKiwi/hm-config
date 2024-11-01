{ lib

, fetchFromGitHub

, buildGoModule
}:
buildGoModule rec {
  pname = "act";
  version = "0.2.69";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Aqs6mIP4pJm0ynExMsmSh3CCtgZY1H3er3ZoXggHOk0=";
  };

  vendorHash = "sha256-VZbzyGb9DI3O5IoNtBneiziY7zPF3mlrDqRlBUPsdEM=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kashw2 ];
  };
}
