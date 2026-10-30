#!/usr/bin/env sh
set -eu

PREFIX="${PREFIX:-/usr/local}"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/dot"

KEEP_DATA=0
for arg in "$@"; do
	case "$arg" in
	--keep-data) KEEP_DATA=1 ;;
	-h | --help)
		printf 'usage: uninstall.sh [--keep-data]\n'
		exit 0
		;;
	*)
		printf 'error: unknown option: %s\n' "$arg" >&2
		exit 1
		;;
	esac
done

say() {
	printf '%s\n' "$*"
}

remove_binary() {
	path="$1"
	[ -f "$path" ] || return 1
	if [ -w "$path" ] && rm -f "$path"; then
		return 0
	fi
	if command -v sudo >/dev/null 2>&1 && sudo rm -f "$path"; then
		return 0
	fi
	printf 'warning: cannot remove %s (permissions)\n' "$path" >&2
	return 1
}

if command -v dot >/dev/null 2>&1; then
	say "==> dot uninstall --all"
	dot uninstall --all || say "warning: some links were not removed; check them manually"
else
	say "· dot is not in PATH, skipping unlink"
fi

REMOVED=0
for candidate in \
	"$PREFIX/bin/dot" \
	"/usr/local/bin/dot" \
	"$HOME/.local/bin/dot" \
	"$HOME/.cargo/bin/dot"; do
	if remove_binary "$candidate"; then
		say "✓ binary removed: $candidate"
		REMOVED=1
	fi
done

STILL=$(command -v dot 2>/dev/null || true)
if [ -n "$STILL" ]; then
	say "warning: there is still a dot in PATH: $STILL"
fi
if [ "$REMOVED" -eq 0 ] && [ -z "$STILL" ]; then
	say "· could not find the dot binary"
fi

if [ "$KEEP_DATA" -eq 1 ]; then
	say "· data kept at $DATA_DIR"
elif [ -d "$DATA_DIR" ]; then
	if [ -d "$DATA_DIR/backups" ]; then
		say "warning: backups at $DATA_DIR/backups will be deleted"
	fi
	rm -rf "$DATA_DIR"
	say "✓ data removed: $DATA_DIR"
fi

say "✓ dot uninstalled"
