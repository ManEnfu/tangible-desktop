#!/usr/bin/env bash

amixer -q -D pulse sset Master playback 5%-
sleep 0.05
[[ $XDG_SESSION_DESKTOP == "awesome" ]] && awesome-client "awesome.emit_signal('signal::volume')"
[[ $XDG_SESSION_DESKTOP == "dwm" ]] && pkill -RTMIN+10 dwmblocks
aplay -q ~/.config/scripts/sound_click_tick.wav
