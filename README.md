# dotfiles

Personal configuration managed with symlinks.

## Structure

Each top-level directory is a config package:

```
dotfiles/
├── nvim/       → ~/.config/nvim/
├── agents/     → ~/.agents/
├── Brewfile    → Homebrew dependencies
├── Makefile    → install/uninstall/venv
└── install.sh  → Bootstrap script
```

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/heaveless/dotfiles/master/install.sh)
```

This clones the repo, installs Homebrew + dependencies, and creates symlinks.

## Usage

```bash
make install    # Install deps + python venv + create symlinks
make update     # Pull the repo, refresh deps + symlinks, sync plugins
make uninstall  # Remove symlinks only
make deps       # Homebrew packages only
make venv       # Python venv for molten only
make sync       # lazy.nvim plugin sync only (rewrites lazy-lock.json)
```

## Update

Already cloned? One command:

```bash
make update
```

or, for a fresh machine bootstrap plus update:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/heaveless/dotfiles/master/install.sh) update
```

`make update` runs `git pull --ff-only`, then `make install` (idempotent: brew deps,
molten venv, symlinks) and `make sync` (`nvim --headless "+Lazy! sync"`).
It aborts if the checkout has diverged or uncommitted changes block the merge.

The lockfile changes it produces are meant to be committed, so every machine
ends up on the same plugin revisions.
