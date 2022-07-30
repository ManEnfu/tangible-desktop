#!/bin/sh

brightnessctl s +10%

sleep 0.05
[[ $XDG_SESSION_DESKTOP == "none+awesome" ]] && awesome-client "awesome.emit_signal('signal::brightness')"
