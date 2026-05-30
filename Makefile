PACKAGES := nvim agents

.PHONY: stow unstow restow install

stow:
	@echo "Linking packages..."
	@stow -v $(PACKAGES)

unstow:
	@echo "Unlinking packages..."
	@stow -vD $(PACKAGES)

restow:
	@echo "Relinking packages..."
	@stow -vR $(PACKAGES)

install:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@echo "Installing dependencies..."
	@brew bundle --file Brewfile
	@$(MAKE) stow
