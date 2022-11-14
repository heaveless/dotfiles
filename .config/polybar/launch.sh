#!/usr/bin/env bash
# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar


# Wait until the processes have been shut down
# while pgrep -x polybar >/dev/null; do sleep 1; done
#

echo "polybar starting..."

polybar --reload main &

echo "polybar launched..."
