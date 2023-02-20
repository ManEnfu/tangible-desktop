{ stdenvNoCC
, lib
}:

stdenvNoCC.mkDerivation {
  name = "tangible-icons";
  src = ../fonts/TangibleIcons.ttf;

  dontUnpack = true;

  installPhase = ''
    local out_ttf=$out/share/fonts/truetype/tangible-icons
    mkdir -p $out_ttf
    install -Dm444 $src $out_ttf/TangibleIcons.ttf 
  '';

  meta = with lib; {
    description = "Tangible Icons";
    license = licenses.cc0;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
