#!/usr/bin/env sh
set -eu

REPO="${DOT_REPO:-https://github.com/heaveless/dotfiles.git}"
PREFIX="${PREFIX:-/usr/local}"
BIN_DIR="$PREFIX/bin"

die() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

say() {
	printf '%s\n' "$*"
}

command -v cargo >/dev/null 2>&1 || die "cargo is missing; install Rust from https://rustup.rs"

SUDO=""
need_root() {
	command -v sudo >/dev/null 2>&1 || die "cannot write to $BIN_DIR; try PREFIX=\$HOME/.local"
	SUDO="sudo"
}

if ! mkdir -p "$BIN_DIR" 2>/dev/null; then
	need_root
	$SUDO mkdir -p "$BIN_DIR"
fi
if [ ! -w "$BIN_DIR" ]; then
	need_root
fi

WORKDIR=""
cleanup() {
	if [ -n "$WORKDIR" ]; then
		rm -rf "$WORKDIR"
	fi
}
trap cleanup EXIT INT TERM

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
if [ -f "$SCRIPT_DIR/Cargo.toml" ]; then
	SOURCE="$SCRIPT_DIR"
else
	command -v git >/dev/null 2>&1 || die "git is missing"
	WORKDIR=$(mktemp -d)
	say "==> cloning $REPO"
	git clone --depth 1 "$REPO" "$WORKDIR/dotfiles"
	SOURCE="$WORKDIR/dotfiles"
fi

say "==> building dot"
cargo build --release --manifest-path "$SOURCE/Cargo.toml"

$SUDO mkdir -p "$BIN_DIR"
$SUDO install -m 0755 "$SOURCE/target/release/dot" "$BIN_DIR/dot"

say "✓ dot installed at $BIN_DIR/dot"
"$BIN_DIR/dot" --version

case ":$PATH:" in
*":$BIN_DIR:"*) ;;
*) say "warning: $BIN_DIR is not in PATH" ;;
esac

say ""
say "next:"
say "  dot init $REPO"
say "  dot install --all"
