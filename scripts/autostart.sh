#!/usr/bin/env bash

function run {
    if ! pgrep -f $1 ; then
        $@&
    fi
}

amixer -D pulse > /dev/null

run ~/.fehbg
run picom --experimental-backend
run nm-applet
run lxpolkit
# run lxqt-policykit-agent

[[ $XDG_SESSION_DESKTOP == "dwm" ]] && run dwmblocks
if [[ $XDG_SESSION_DESKTOP == "wmaker" ]]; then
    run stalonetray --dockapp-mode wmaker --slot-size 32 --geometry 2x2 \
        --parent-bg --scrollbars none
    run wmblueclock
    run wmbluemem
    run wmbluecpu
    run wmamixer -w
fi
