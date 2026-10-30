#!/bin/sh
set -eu

venv="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/molten-venv"

if [ -x "$venv/bin/python3" ]; then
	exit 0
fi

echo "==> creating venv at $venv"
python3 -m venv "$venv"
"$venv/bin/pip" install --quiet --upgrade pip pynvim jupyter
