{ lib

, fetchFromGitLab

, python3Packages
}:
python3Packages.buildPythonApplication {
  pname = "szurubooru-cli";
  version = "0-unstable-2024-08-09";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "kokakiwi";
    repo = "szurubooru-cli";
    rev = "c028c733b37eb74f0fc27dd08c2412bdab3d4fc0";
    hash = "sha256-yzlsL7TQSK6LeFgyqrPOF+WOS3At3FUZ2zQhI41Kyac=";
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
