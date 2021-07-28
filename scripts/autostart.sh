#!/usr/bin/env bash

function run {
    if ! pgrep -f $1 ; then
        $@&
    fi
}

run ~/.fehbg
run picom
run nm-applet
run lxpolkit

[[ $XDG_SESSION_DESKTOP == "dwm" ]] && run dwmblocks
