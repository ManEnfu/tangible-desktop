{ stdenv
, lib
, python310
}:

stdenv.mkDerivation rec {
  name = "tangible-desktop-scripts";
  src = ../scripts;

  buildInputs = [
    (python310.withPackages (p: with p; [
      pulsectl
      watchdog
    ]))
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/tangible-desktop-scripts
    install -Dm644 $src/*.wav $out/share/tangible-desktop-scripts
    install -Dm755 $src/tgd-* $out/bin

    runHook postInstall
  '';

  postInstall = ''
    sed "2 i share=$out/share/tangible-desktop-scripts" \
      -i $out/bin/tgd-vol
  '';

  meta = with lib; {
    description = "Tangible Desktop Scripts";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
