#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-install}"
DOTFILES="${DOTFILES:-${HOME}/dotfiles}"

case "${ACTION}" in
install | update) ;;
*)
	echo "usage: install.sh [install|update]" >&2
	exit 1
	;;
esac

if [ ! -d "${DOTFILES}/.git" ]; then
	if [ -e "${DOTFILES}" ]; then
		echo "error: ${DOTFILES} exists but is not a git checkout of dotfiles" >&2
		exit 1
	fi
	if [ "${ACTION}" = "update" ]; then
		echo "error: nothing to update, ${DOTFILES} is not cloned yet" >&2
		exit 1
	fi
	git clone https://github.com/heaveless/dotfiles.git "${DOTFILES}"
fi

cd "${DOTFILES}" && make "${ACTION}"
