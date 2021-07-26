#!/bin/env bash

slot=$(date "+%a *%H")

csched=$(cat ~/.config/scripts/myschedule.txt | awk "/$slot/" | sed "s/$slot *//")

[[ -z $csched ]] && date "+%A, %d %B %Y | %H:%M" && exit

echo "$csched | $(date '+%a, %d %b | %H:%M')"



