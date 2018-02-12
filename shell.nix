let
  config = {
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: rec {
          retirement-graphics =
            haskellPackagesNew.callPackage ./graphics/default.nix { };
        };
      };
    };
  };


  pkgs = import <nixpkgs> {inherit config; };
  stdenv = pkgs.stdenv;

  haskellEnv = pkgs.haskell.packages.ghc822.ghcWithPackages
      (haskellPackages: with haskellPackages; [
        # libraries
        pandoc
      ]);

in with pkgs; {
  myProject = stdenv.mkDerivation {
    name = "retirement";
    version = "1";
    src = if pkgs.lib.inNixShell then null else nix;

    buildInputs = with rPackages; [
      R
      tidyverse
      RPostgreSQL
      codetools
      haskellEnv
      pkgs.haskellPackages.retirement-graphics
      gnumake
      postgresql ];
  };
}
