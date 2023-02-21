#!/bin/sh

function run {
    if ! pgrep -f $1 ; then
        $@&
    fi
}

run ~/.fehbg
run picom --experimental-backend --config ~/.config/awesome/picom.conf
run nm-applet --indicator
run lxpolkit
