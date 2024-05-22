{ lib

, fetchFromGitHub
, fetchFromGitLab

, makeWrapper
, python3Packages

, cargo
}:
let
  aiohttp-mako = python3Packages.buildPythonPackage {
    pname = "aiohttp-mako";
    version = "0.4.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "aio-libs";
      repo = "aiohttp-mako";
      rev = "8fb66bd35b8cb4a2fa91e33f3dff918e4798a15a";
      hash = "sha256-1Z8SAziKmiuxIgfjCemUpknywmZEMdTRNiXal4/Onug=";
    };

    nativeBuildInputs = with python3Packages; [
      pip
      setuptools
    ];
    propagatedBuildInputs = with python3Packages; [
      aiohttp
      mako
    ];
  };
in python3Packages.buildPythonApplication {
  pname = "module-server";
  version = "0.1.0";
  format = "pyproject";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "web";
    repo = "module-server";
    rev = "a9fbe0b66fc93e74dc67b422798e48b0cd3a340b";
    hash = "sha256-Uo1O12a9h4YfU+HAXiTkAsGGaZvlWvBYOScO2tn+ReU=";
  };

  nativeBuildInputs = with python3Packages; [
    makeWrapper

    pdm-backend
  ];
  propagatedBuildInputs = with python3Packages; [
    aiohttp
    aiohttp-mako
    appdirs
    asyncinotify
    click
    pydantic
    libsass
    python-slugify
    ruamel-yaml
    semver
    yarl
    yattag
    loguru
  ];

  configurePhase = ''
    python -m module_server --compile-style
  '';

  postInstall = ''
    wrapProgram $out/bin/module-server \
      --prefix PATH : "${lib.makeBinPath [ cargo ]}"
  '';

  meta = {
    mainProgram = "module-server";
  };
}
