#!/bin/sh

function run {
    if ! pgrep -f $1 ; then
        $@&
    fi
}

run ~/.fehbg
run picom --experimental-backend
run nm-applet --indicator
run lxpolkit
run libinput-gestures
