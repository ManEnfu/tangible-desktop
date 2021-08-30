#!/usr/bin/env bash

up_time=$(uptime -p)
username=$(id -un)

theme="$HOME/.config/rofi/powermenu-theme.rasi"

option_sleep=""
option_reboot=""
option_poweroff=""
option_lock=""
option_logout=""

declare -a options=(
    $option_sleep
    $option_reboot
    $option_poweroff
    $option_lock
    $option_logout
)

choice=$(\
    printf '%s\n' "${options[@]}" | \
    rofi -dmenu -p "$up_time" -i -theme "$theme")

if [[ $choice == $option_sleep ]]; then
    i3lock -c 242424 && sleep 0.5 && loginctl suspend
elif [[ $choice == $option_reboot ]]; then
    loginctl reboot
elif [[ $choice == $option_poweroff ]]; then
    loginctl poweroff
elif [[ $choice == $option_lock ]]; then
    i3lock -c 242424
elif [[ $choice == $option_logout ]]; then
    if [[ $XDG_SESSION_DESKTOP == "awesome" ]]; then 
        awesome-client "awesome.quit()"
    else 
        loginctl kill-user $username
    fi
fi
