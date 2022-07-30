#!/bin/sh

set -e

handle () {
    if [ ${1:0:12} = "activewindow" ]; then
        data=${1:14}
        name=$(echo $data | sed 's/,.*//')
        echo $name
    fi
}

if [ $XDG_CURRENT_DESKTOP = "hyprland" ]; then
    socat - UNIX-CONNECT:/tmp/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock \
        | while read line; do handle $line; done
fi
