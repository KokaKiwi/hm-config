_default:

_run-shell COMMAND:
  nix-shell --run '{{COMMAND}}'

build: (_run-shell 'build')
switch: (_run-shell 'switch')
build-package NAME: (_run-shell ('buildPackage ' + quote(NAME)))
update-package NAME *ARGS: (_run-shell ('updatePackage ' + quote(NAME) + ' ' + ARGS))
copy-package SRC DST: (_run-shell ('copyPackage ' + quote(SRC) + ' ' + quote(DST)))
list-packages: (_run-shell 'listPackages')
option PATH: (_run-shell ('showOption ' + quote(PATH)))

repl:
  nix repl --file default.nix

update *NAMES:
  niv update {{NAMES}}

commit-update NAMES:
  git add nix
  git commit -m 'chore: Update dependencies ({{NAMES}})'

update-nur:
  niv -s nix/sources-nur.json update
  -git add nix/sources-nur.json && git commit -m 'chore(deps): Update NUR'

push:
  git push -f origin main

check:
  nvchecker -c .nvchecker.toml

clean:
  -rm result*
