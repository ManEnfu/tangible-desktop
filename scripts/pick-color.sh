#!/bin/sh

if COLOR=$(xcolor); then
    notify-send "Color Picked" "$COLOR" -t 5000
    echo $COLOR | xclip -selection clipboard
fi
