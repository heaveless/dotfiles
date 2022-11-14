if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	exec startx
fi

setxkbmap latam

source ~/.config/terminal/main

ZDOTDIR=~/.config/zsh
