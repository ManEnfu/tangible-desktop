#!/bin/sh

ambient_files=$(echo 'Stop Playing' && ls -1 ~/Musics/ambient)

declare -a ambient_list=$ambient_files

choice=$(printf '%s\n' "${ambient_list[@]}" | rofi -dmenu -p ' ' -i)

if [ "$choice" == "Stop Playing" ]; then
    killall mpv
elif [ "$choice" != "" ]; then
    killall mpv
    mpv --loop --quiet ~/Musics/ambient/"$choice" || exit
fi
