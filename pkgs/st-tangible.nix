{ lib
, stdenv
, fetchurl
, pkg-config
, fontconfig
, freetype
, libX11
, libXft
, ncurses
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "st-tangible";
  version = "0.9";

  src = ../desktop/dwm/st;

  strictDeps = true;
  
  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
  ];

  nativeBuildInputs = [
    pkg-config
    ncurses
    fontconfig
    freetype
  ];
  buildInputs = [
    libX11
    libXft
  ];

  preInstall = ''
    export TERMINFO=$out/share/terminfo
  '';

  installFlags = [ "PREFIX=$(out)" ];

  passthru.tests.test = nixosTests.terminal-emulators.st;

  meta = with lib; {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [ andsild ];
    platforms = platforms.unix;
  };
})
