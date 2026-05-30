#!/usr/bin/env bash
set -euo pipefail
DOTFILES="${HOME}/dotfiles"
if [ ! -d "$DOTFILES" ]; then
	git clone https://github.com/heaveless/dotfiles.git "$DOTFILES"
fi
cd "$DOTFILES" && make install
