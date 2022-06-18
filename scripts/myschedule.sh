#!/usr/bin/env bash

slot=$(date "+%a *%H")

csched=$(cat ~/.config/scripts/myschedule.txt | awk "/$slot/" | sed "s/$slot *//")

if [[ -z $csched ]]; then
    echo ""
else
    echo "Schedule: $csched"
fi


