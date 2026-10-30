# dotfiles

Personal configuration managed by `dot`, a small dotfiles manager written in Rust.

A **dot** is a folder in this repo. `dot/<name>/config/` is symlinked to
`~/.config/<name>/`, and that is all `dot` does: it clones a repo, links dots,
unlinks them, and updates itself.

```
repo/
├── dot/                     # one folder per dot
│   └── nvim/
│       ├── metadata.yml     # optional: description + install hook
│       ├── config/          # → ~/.config/nvim
│       └── scripts/
└── src/                     # the `dot` crate
```

`dot` keeps everything it owns in `~/.local/share/dot`:

```
~/.local/share/dot/repo      # git clone of this repo
~/.local/share/dot/dot.db    # sqlite: repo + install records
~/.local/share/dot/backups/  # directories displaced by `dot install`
```

The only thing it writes outside of that is the symlink in `~/.config`.

## Install / uninstall

```bash
# system-wide (/usr/local/bin/dot, uses sudo when needed)
bash <(curl -fsSL https://raw.githubusercontent.com/heaveless/dotfiles/master/install.sh)

# per user (~/.local/bin/dot, no sudo)
PREFIX=$HOME/.local bash <(curl -fsSL https://raw.githubusercontent.com/heaveless/dotfiles/master/install.sh)

# uninstall: links + binary + ~/.local/share/dot
bash <(curl -fsSL https://raw.githubusercontent.com/heaveless/dotfiles/master/uninstall.sh)

# keep db, clone and backups
bash <(curl -fsSL https://raw.githubusercontent.com/heaveless/dotfiles/master/uninstall.sh) --keep-data
```

`install.sh` only installs the binary (building this checkout, or cloning the repo
into a temp dir). Then:

```bash
dot init <repo>
dot install --all
```

## Commands

```bash
dot init <repo>          # point at a git repo (or a local checkout)
dot list                 # columns, docker-style: NAME STATE DESCRIPTION
dot list -q              # names only
dot install <dot>...     # link one or more dots (pulls the repo first)
dot install --all        # link every dot (pulls the repo first)
dot uninstall <dot>...   # unlink
dot uninstall --all      # unlink every dot
dot update               # git pull the repo, rebuild and replace the binary
```

## Adding a dot

```bash
mkdir -p dot/mytool/config
mv ~/.config/mytool/* dot/mytool/config/
dot install mytool
```

`metadata.yml` is optional:

```yaml
description: My tool
hooks:
  install: ./scripts/setup.sh   # runs on install, cwd = dot/mytool
```

## Releases

```bash
git tag v0.1.0
git push origin v0.1.0
```

`.github/workflows/release.yml` builds `dot` for macOS (arm64, x86_64) and Linux
(x86_64, arm64) and publishes, for each target:

```
dot-v<version>-<target>.tar.gz
dot-v<version>-<target>.tar.gz.sha256
```

The tag must match the version in `Cargo.toml`, otherwise the workflow fails
before building. It can also be started manually from the Actions tab, passing
the tag as input.

`.github/workflows/ci.yml` runs `cargo fmt --check`, `cargo clippy -D warnings`
and `cargo test` on every push to `master` and on pull requests.

## Updating

`dot update` runs `git pull --ff-only` in the clone and rebuilds the binary. Since
dots are symlinks into the clone, the pull already updates your configuration;
there is no need to re-link after it.

## Dev

```bash
cargo test
cargo run -- list
```
