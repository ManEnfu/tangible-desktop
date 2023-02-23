{ lib
, stdenv
, fetchurl
, libX11
, libXinerama
, libXft
, writeText
, patches ? [ ]
, conf ? null
}:

stdenv.mkDerivation rec {
  pname = "dwm-tangible";
  version = "6.3";

  src = ../desktop/dwm/dwm;

  buildInputs = [ libX11 libXinerama libXft ];

  prePatch = ''
    sed -i "s@/usr/local@$out@" config.mk
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    homepage = "https://dwm.suckless.org/";
    description = "An extremely fast, small, and dynamic window manager for X";
    longDescription = ''
      dwm is a dynamic window manager for X. It manages windows in tiled,
      monocle and floating layouts. All of the layouts can be applied
      dynamically, optimising the environment for the application in use and the
      task performed.
      Windows are grouped by tags. Each window can be tagged with one or
      multiple tags. Selecting certain tags displays all windows with these
      tags.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ viric neonfuz ];
    platforms = platforms.all;
  };
}
