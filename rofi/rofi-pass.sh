#!/usr/bin/env bash

shopt -s nullglob globstar

typeit=0
if [[ $1 == "--type" ]]; then
	typeit=1
	shift
fi

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | rofi -dmenu -p "聾" -i)

[[ -n $password ]] || exit

if [[ $typeit -eq 0 ]]; then
	PASSWORD_STORE_CLIP_TIME=8 pass show -c "$password" 2>/dev/null && notify-send "Password Manager" "Password for $password copied to clipboard and will be cleared in $PASSWORD_STORE_CLIP_TIME seconds."
else
	pass show "$password" | { IFS= read -r pass; printf %s "$pass"; } |
		xdotool type --clearmodifiers --file -
fi
