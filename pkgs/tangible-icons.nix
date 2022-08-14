{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "tangible-icons";
  src = ../fonts/TangibleIcons.ttf;

  installPhase = ''
    local out_ttf=$out/share/fonts/truetype/tangible-icons
    mkdir -p $out_ttf
    install -m444 -Dt $out_tff TangibleIcons.ttf 
  '';

  meta = with lib; {
    description = "Tangible Icons";
    license = licenses.cc0;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
