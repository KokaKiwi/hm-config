_default:

_run-shell COMMAND *ARGS:
  nix-shell {{ARGS}} --run '{{COMMAND}}'

build: (_run-shell 'build')
switch: (_run-shell 'switch')
copy-package SRC DST: (_run-shell ('copyPackage ' + quote(SRC) + ' ' + quote(DST)))
list-packages: (_run-shell 'listPackages')
option PATH: (_run-shell ('showOption ' + quote(PATH)))
check: (_run-shell 'checkUpdates' '--arg doWarn true')

build-package ATTR:
  NIXPKGS_ALLOW_BROKEN=1 nom-build -A "pkgs.{{ATTR}}"
build-home-package ATTR:
  NIXPKGS_ALLOW_BROKEN=1 nom-build -A "homePackages.{{ATTR}}"

update-package ATTR *ARGS:
  nix-update "pkgs.{{ATTR}}" {{ARGS}}

repl:
  nix repl --expr '(import ./default.nix { }).env'

update *NAMES:
  npins update {{NAMES}}

commit-update NAMES:
  git add npins && git commit -m 'chore(deps): Update ({{NAMES}})'

update-nur:
  npins -d npins/nur update
  -git add npins/nur && git commit -m 'chore(deps): Update NUR'

push:
  git push -f origin main

clean:
  -rm result*
