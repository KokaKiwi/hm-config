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
    rev = "f9c33ebf14ee46c0c086d37ee23748b8661cae5e";
    hash = "sha256-sH07mgdvCFLeIAmRAcEX9Z0c1VjtEcTyYBKopedIg9c=";
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
