{ lib

, fetchFromGitHub

, python3Packages

, bzip2
, cabextract
, gnutar
, gzip
, lzip
, p7zip
, unar
, xz
, zip
, zpaq
, zstd
}: let
  compression-utilities = [
    bzip2
    cabextract
    gnutar
    gzip
    lzip
    p7zip
    unar
    xz
    zip
    zpaq
    zstd
  ];
in python3Packages.buildPythonPackage rec {
  pname = "patool";
  version = "2.3.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wummel";
    repo = "patool";
    rev = "upstream/${version}";
    hash = "sha256-WYyz/DiRA7NN7eNQigHPnul2Cfl4hAKobzP6iIyCP0U=";
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ] ++ compression-utilities;

  disabledTests = [
    "test_unzip"
    "test_unzip_file"
    "test_zip"
    "test_zip_file"
  ];

  postInstall = ''
    wrapProgram $out/bin/patool \
      --suffix PATH : "${lib.makeBinPath compression-utilities}"
  '';

  meta = with lib; {
    description = "portable archive file manager";
    mainProgram = "patool";
    homepage = "https://wummel.github.io/patool/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ marius851000 ];
  };
}
