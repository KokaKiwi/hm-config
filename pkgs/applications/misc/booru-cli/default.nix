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
    rev = "d0f765efbc15189fa0e5331f2f60db916415a7f5";
    hash = "sha256-HZHzeoETKvNaM5b0anPkERnTyKAHYeS0p03qkUzjpC8=";
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
