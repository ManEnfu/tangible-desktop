#!/usr/bin/env bash

[[ $XDG_SESSION_DESKTOP == "awesome" ]] && awesome-client "require('awful').tag.viewnext()"
