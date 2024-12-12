{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-+uaJGzK5JE0ZoAyryrjw2mV5zKTB77npKneYU41xETA=";
  };

  cargoHash = "sha256-Y01nQTQQDl0wsagIksnqxqtKK+PoYJSIQKVuTqBOzPU=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
