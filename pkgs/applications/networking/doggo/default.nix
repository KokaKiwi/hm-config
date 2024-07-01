{ lib

, fetchFromGitHub

, buildGoModule
, installShellFiles
}:
buildGoModule rec {
  pname = "doggo";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mr-karan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UNcU//meWcIvnZea1j7QBy4bkedCIV42XWVfYIQh9iw=";
  };

  vendorHash = "sha256-RdxEf8AsN+K0GW4+XVNPHUOtZ8+0Ge0cHZVQwMuVZog=";
  nativeBuildInputs = [ installShellFiles ];
  subPackages = [ "cmd" ];

  ldflags = [
    "-w -s"
    "-X main.buildVersion=v${version}"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/doggo

    installShellCompletion --cmd doggo \
      --bash <($out/bin/doggo completions bash) \
      --fish <($out/bin/doggo completions fish) \
      --zsh <($out/bin/doggo completions zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/mr-karan/doggo";
    description = "Command-line DNS Client for Humans. Written in Golang";
    mainProgram = "doggo";
    longDescription = ''
      doggo is a modern command-line DNS client (like dig) written in Golang.
      It outputs information in a neat concise manner and supports protocols like DoH, DoT, DoQ, and DNSCrypt as well
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ georgesalkhouri ];
  };
}
