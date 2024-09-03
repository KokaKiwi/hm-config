{ lib

, fetchFromGitHub

, python3Packages
}:
python3Packages.buildPythonApplication rec {
  pname = "litecli";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "dbcli";
    repo = "litecli";
    rev = "v${version}";
    hash = "sha256-Fh5EkNS3XTERdysCKVidbGawkOgUq90GMeVfsg/6Mfs=";
  };

  propagatedBuildInputs = with python3Packages; [
    cli-helpers
    click
    configobj
    prompt-toolkit
    pygments
    sqlparse
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "litecli" ];

  disabledTests = [
    "test_auto_escaped_col_names"
  ];

  meta = with lib; {
    description = "Command-line interface for SQLite";
    mainProgram = "litecli";
    longDescription = ''
      A command-line client for SQLite databases that has auto-completion and syntax highlighting.
    '';
    homepage = "https://litecli.com";
    changelog = "https://github.com/dbcli/litecli/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
