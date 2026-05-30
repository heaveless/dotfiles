# dotfiles

Personal configuration managed with symlinks.

## Structure

Each top-level directory is a config package:

```
dotfiles/
├── nvim/       → ~/.config/nvim/
├── agents/     → ~/.agents/
├── Brewfile    → Homebrew dependencies
├── Makefile    → install/uninstall
└── install.sh  → Bootstrap script
```

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/heaveless/dotfiles/master/install.sh)
```

This clones the repo, installs Homebrew + dependencies, and creates symlinks.

## Usage

```bash
make install    # Install deps + create symlinks
make uninstall  # Remove symlinks
```
