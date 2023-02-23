{ lib
, stdenv
, fetchFromGitHub
, libX11
}:

stdenv.mkDerivation {
  pname = "dwmblocks-tangible";
  version = "unstable-2020-12-27";

  src = ../desktop/dwm/dwmblocks;

  buildInputs = [ libX11 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Modular status bar for dwm written in c";
    homepage = "https://github.com/torrinfail/dwmblocks";
    license = licenses.isc;
    maintainers = with maintainers; [ sophrosyne ];
    platforms = platforms.linux;
  };
}
