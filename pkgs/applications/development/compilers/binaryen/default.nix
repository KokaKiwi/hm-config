{ lib, stdenv

, fetchFromGitHub

, cmake
, python3

, gtest
, lit
, nodejs
, filecheck
}:
stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "120_b";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    hash = "sha256-gdqjsAQp4NTHROAf6i44GjkbtNyLPQZ153k3veK7eYs=";
  };

  nativeBuildInputs = [ cmake python3 ];

  preConfigure = ''
    if [ $doCheck -eq 1 ]; then
      sed -i '/googletest/d' third_party/CMakeLists.txt
    else
      cmakeFlagsArray=($cmakeFlagsArray -DBUILD_TESTS=0)
    fi
  '';

  nativeCheckInputs = [ gtest lit nodejs filecheck ];
  checkPhase = ''
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib python3 ../check.py $tests
  '';

  tests = [
    "version" "wasm-opt" "wasm-dis"
    "crash" "dylink" "ctor-eval"
    "wasm-metadce" "wasm-reduce" "spec"
    "lld" "validator"
    "example" "unit"
    # "binaryenjs" "binaryenjs_wasm" # not building this
    # "wasm2js"
    "lit" "gtest"
  ];
  doCheck = stdenv.hostPlatform.isLinux;

  meta = with lib; {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa willcohen ];
    license = licenses.asl20;
  };
}
