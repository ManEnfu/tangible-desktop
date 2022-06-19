#!/bin/sh

[[ $XDG_SESSION_DESKTOP == "none+awesome" ]] && awesome-client "require('awful').tag.viewprev()"
