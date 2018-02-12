{ mkDerivation, aeson, base, blaze-markup, blaze-svg, bytestring
, double-conversion, palette, postgresql-simple, stdenv
}:
mkDerivation {
  pname = "graphics";
  version = "0.1.0.0";
  src = ./graphics;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base blaze-markup blaze-svg bytestring double-conversion
    palette postgresql-simple
  ];
  license = stdenv.lib.licenses.bsd3;
}
