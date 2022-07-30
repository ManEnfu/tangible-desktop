#!/bin/sh

sleep 0.2 && scrot -s '%Y-%m-%d_%H-%M-%S_$wx$h.png' -e 'mv $f ~/Pictures/Screenshots/ 2>/dev/null && notify-send \"Screenshot taken\" \"$f\" -t 5000 -i ~/Pictures/Screenshots/$f'
