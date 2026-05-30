DOTFILES := $(shell pwd)

.PHONY: install uninstall deps

deps:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@brew bundle --file $(DOTFILES)/Brewfile

install: deps
	@ln -sfn $(DOTFILES)/nvim $(HOME)/.config/nvim
	@ln -sfn $(DOTFILES)/agents $(HOME)/.agents
	@echo "Installed."

uninstall:
	@rm -f $(HOME)/.config/nvim
	@rm -f $(HOME)/.agents
	@echo "Removed."
