# dotfiles

Personal configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/heaveless/dotfiles/master/install.sh)
```

## Packages

| Package | Target | Description |
|---------|--------|-------------|
| `nvim` | `~/.config/nvim/` | Neovim editor |
| `agents` | `~/.agents/` | AI agent skills |

## Usage

```bash
make stow      # Create all symlinks
make unstow    # Remove all symlinks
make restow    # Recreate all symlinks
```
