_default:

_run-shell COMMAND *ARGS:
  nix-shell {{ARGS}} --run '{{COMMAND}}'

build: (_run-shell 'build')
switch: (_run-shell 'switch')
build-package NAME: (_run-shell ('buildPackage ' + quote(NAME)))
update-package NAME *ARGS: (_run-shell ('updatePackage ' + quote(NAME) + ' ' + ARGS))
copy-package SRC DST: (_run-shell ('copyPackage ' + quote(SRC) + ' ' + quote(DST)))
list-packages: (_run-shell 'listPackages')
option PATH: (_run-shell ('showOption ' + quote(PATH)))
check: (_run-shell 'checkUpdates' '--arg doWarn true')

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
