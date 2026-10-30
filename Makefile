DOTFILES := $(shell pwd)

NVIM_LINK := $(HOME)/.config/nvim
AGENTS_LINK := $(HOME)/.agents
MOLTEN_VENV := $(HOME)/.local/share/nvim/molten-venv

.PHONY: install uninstall deps venv

deps:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@brew bundle --file $(DOTFILES)/Brewfile

venv:
	@if [ ! -x $(MOLTEN_VENV)/bin/python3 ]; then \
		echo "Creating molten venv at $(MOLTEN_VENV)..."; \
		python3 -m venv $(MOLTEN_VENV) && \
		$(MOLTEN_VENV)/bin/pip install --quiet --upgrade pip pynvim jupyter; \
	fi

install: deps venv
	@if [ -e $(NVIM_LINK) ] && [ ! -L $(NVIM_LINK) ]; then \
		echo "Backing up $(NVIM_LINK) -> $(NVIM_LINK).bak"; \
		mv $(NVIM_LINK) $(NVIM_LINK).bak; \
	fi
	@if [ -e $(AGENTS_LINK) ] && [ ! -L $(AGENTS_LINK) ]; then \
		echo "Backing up $(AGENTS_LINK) -> $(AGENTS_LINK).bak"; \
		mv $(AGENTS_LINK) $(AGENTS_LINK).bak; \
	fi
	@mkdir -p $(HOME)/.config
	@ln -sfn $(DOTFILES)/nvim $(NVIM_LINK)
	@ln -sfn $(DOTFILES)/agents $(AGENTS_LINK)
	@echo "Installed."

uninstall:
	@for target in $(NVIM_LINK) $(AGENTS_LINK); do \
		if [ -L $$target ]; then \
			rm $$target && echo "Removed $$target"; \
		elif [ -e $$target ]; then \
			echo "Skipped $$target (not a symlink; remove it manually)"; \
		fi; \
	done
