{ mkDerivation, aeson, base, blaze-markup, blaze-svg, bytestring
, colour, double-conversion, filepath, palette, postgresql-simple
, stdenv
}:
mkDerivation {
  pname = "graphics";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base blaze-markup blaze-svg bytestring colour
    double-conversion filepath palette postgresql-simple
  ];
  license = stdenv.lib.licenses.bsd3;
}
