#!/usr/bin/env bash

up_time=$(uptime -p)

theme="$HOME/.config/rofi/powermenu-theme.rasi"

option_sleep="sleep"
option_reboot="reboot"
option_poweroff="poweroff"
option_lock="lock"
option_logout="logout"

declare -a options=(
    $option_sleep
    $option_reboot
    $option_poweroff
    $option_lock
    $option_logout
)

choice=$(\
    printf '%s\n' "${options[@]}" | \
    dmenu -p power)

if [[ $choice == $option_sleep ]]; then
    i3lock -c 242424 && sleep 0.5 && loginctl suspend
elif [[ $choice == $option_reboot ]]; then
    loginctl reboot
elif [[ $choice == $option_poweroff ]]; then
    loginctl poweroff
elif [[ $choice == $option_lock ]]; then
    i3lock -c 242424
elif [[ $choice == $option_logout ]]; then
    [[ $XDG_SESSION_DESKTOP == "awesome" ]] && awesome-client "awesome.quit()"
fi
