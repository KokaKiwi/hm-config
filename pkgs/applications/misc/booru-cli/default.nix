{ lib

, fetchFromGitLab

, python3Packages
}:
python3Packages.buildPythonApplication {
  pname = "szurubooru-cli";
  version = "0-unstable-2024-08-08";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "kokakiwi";
    repo = "szurubooru-cli";
    rev = "c2fe65a18d7a60305154829d040117aa59ceec5a";
    hash = "sha256-W9QGRxkO8PGcISgrB/nIsi0DKL0PC/Bc0lyYfRMujug=";
  };

  nativeBuildInputs = with python3Packages; [
    pdm-backend
  ];

  propagatedBuildInputs = with python3Packages; [
    httpx h2
    rtoml
    tqdm
    typer
    devtools
  ];

  pythonImportsCheck = [ "booru" ];

  meta = with lib; {
    description = "";
    homepage = "https://gitlab.kokakiwi.net/kokakiwi/szurubooru-cli";
    mainProgram = "szurubooru-cli";
  };
}
