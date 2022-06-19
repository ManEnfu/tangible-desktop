#!/bin/sh

amixer -q sset Master toggle
sleep 0.05
[[ $XDG_SESSION_DESKTOP == "none+awesome" ]] && awesome-client "awesome.emit_signal('signal::volume')"
[[ $XDG_SESSION_DESKTOP == "dwm" ]] && pkill -RTMIN+10 dwmblocks
aplay -q ~/.config/scripts/sound_click_tick.wav

