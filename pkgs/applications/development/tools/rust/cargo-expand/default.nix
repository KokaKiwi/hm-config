{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.93";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    hash = "sha256-IoZ2QnwtKjHK+wqCkmwV0P9IlIqAlpOCS7GolXw9ftA=";
  };

  cargoHash = "sha256-wl84Qluob5g6oHvjzWpP0XHVNs5Pf5OZDXWWj8QAfFE=";

  meta = with lib; {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda xrelkd ];
    mainProgram = "cargo-expand";
  };
}
