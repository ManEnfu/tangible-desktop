#!/bin/sh

pactl set-sink-volume $(pactl get-default-sink) +5%
# limit to 100%
pactl get-sink-volume $(pactl get-default-sink) | grep -q -e '1..\%' && \
    pactl set-sink-volume $(pactl-get-default-sink) 100%

sleep 0.05
[[ $XDG_SESSION_DESKTOP == "none+awesome" ]] && awesome-client "awesome.emit_signal('signal::volume')"
[[ $XDG_SESSION_DESKTOP == "dwm" ]] && pkill -RTMIN+10 dwmblocks
paplay -q ~/.config/scripts/sound_click_tick.wav
