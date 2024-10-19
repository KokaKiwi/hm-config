{ lib

, fetchpatch
, fetchzip
, srcOnly
}:
let
  version = "2.91.1";

  fetchSource = {
    repo,
    hash ? lib.fakeHash,

    patches ? [ ],
    cherryPicks ? [ ],
    pullRequests ? [ ],
  }: let
    baseUrl = "https://git.lix.systems/lix-project/${repo}";

    finalPatches = let
      fetchCherryPick = {
        id,
        hash ? lib.fakeHash,
      }: fetchpatch {
        name = "${repo}-commit-${lib.strings.substring 0 8 id}";
        url = "${baseUrl}/commit/${id}.patch";
        inherit hash;
      };
      fetchPullRequest = {
        id,
        hash ? lib.fakeHash,
      }: fetchpatch {
        name = "${repo}-pull-${toString id}";
        url = "${baseUrl}/pulls/${toString id}.patch";
        inherit hash;
      };
    in
    (map fetchCherryPick cherryPicks)
    ++ (map fetchPullRequest pullRequests)
    ++ patches;

  in srcOnly {
    name = "${repo}-source";

    src = fetchzip {
      name = "${repo}-base-source";
      url = "${baseUrl}/archive/${version}.tar.gz";
      inherit hash;
    };

    patches = finalPatches;
  };
in {
  lix = fetchSource {
    repo = "lix";
    hash = "sha256-hiGtfzxFkDc9TSYsb96Whg0vnqBVV7CUxyscZNhed0U=";
  };
  nixos-module = fetchSource {
    repo = "nixos-module";
    hash = "sha256-slp0zWHKvbCzhiBwwe6VX6jODEY+PKhHyiAoHgM5Bdc=";

    cherryPicks = [
      {
        id = "81d9ff97c93289bb1592ae702d11173724a643fa";
        hash = "sha256-vjK/C0RrpFCSoG3QiH0Fh8H1eXq0oBT8NVq2WNMNnWI=";
      }
    ];
  };
}
