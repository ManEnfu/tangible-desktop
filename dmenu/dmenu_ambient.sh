#!/usr/bin/env bash

ambient_files=$(echo 'Stop Playing' && /bin/ls -1 ~/Musics/ambient)

declare -a ambient_list=$ambient_files

choice=$(printf '%s\n' "${ambient_list[@]}" | dmenu -p "ambient")

if [ "$choice" == "Stop Playing" ]; then
    killall mpv
elif [ "$choice" != "" ]; then
    killall mpv
    mpv --loop --quiet ~/Musics/ambient/"$choice" || exit
fi
