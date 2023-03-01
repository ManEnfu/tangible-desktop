{ lib
, stdenvNoCC
, fetchgit 
}: 

stdenvNoCC.mkDerivation rec {
  pname = "orchis-kde-theme";
  version = "9899e1d949bf04ea6166687b755ed61e7fcf839b";

  src = fetchgit {
    url = "https://github.com/vinceliuice/Orchis-kde";
    rev = "${version}";
    sha256 = "";
  };

  installPhase = ''
    mkdir -p $out/share
    cp -r Kvantum $out/share
  '';

  meta = with lib; {
    description = "";
    longDescription = "";
    license = licenses.gpl3;
    homepage = "https://github.com/vinceliuice/Orchis-kde";
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
