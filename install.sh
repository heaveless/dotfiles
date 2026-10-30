#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-${HOME}/dotfiles}"

if [ ! -d "${DOTFILES}/.git" ]; then
	if [ -e "${DOTFILES}" ]; then
		echo "error: ${DOTFILES} exists but is not a git checkout of dotfiles" >&2
		exit 1
	fi
	git clone https://github.com/heaveless/dotfiles.git "${DOTFILES}"
fi

cd "${DOTFILES}" && make install
