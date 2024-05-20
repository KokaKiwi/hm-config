{ pkgs, callPackage }:
{
  neovim = callPackage ./neovim {
    llvmPackages = pkgs.llvmPackages_18;
    lua = pkgs.luajit;
  };
}
