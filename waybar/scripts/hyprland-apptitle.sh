#!/bin/sh

set -e

handle () {
    if [ ${1:0:12} = "activewindow" ]; then
        update 
    fi
}

update() {
    NAME=$((hyprctl activewindow | grep "title: " | sed "s/.*title: //") || echo "")
    echo $NAME
}

update

if pgrep Hyprland > /dev/null; then
    socat - UNIX-CONNECT:/tmp/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock \
        | while read line; do handle $line; done
fi
