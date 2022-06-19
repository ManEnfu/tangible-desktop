#!/bin/sh

pactl get-sink-volume $(pactl get-default-sink)
pactl get-sink-mute $(pactl get-default-sink)
