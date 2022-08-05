#!/usr/bin/env bash
# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
 # killall -q polybar


# Wait until the processes have been shut down
# while pgrep -x polybar >/dev/null; do sleep 1; done
#
# screens=$(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f6)
#
# if [[ $(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f4 | cut -d"+" -f2- | uniq | wc -l) == 1 ]]; then
#   MONITOR=$(polybar --list-monitors | cut -d":" -f1) TRAY_POS=right polybar main &
# else
#   primary=$(xrandr --query | grep primary | cut -d" " -f1)
#
#   for m in $screens; do
#     if [[ $primary == $m ]]; then
#         MONITOR=$m TRAY_POS=right polybar NPink &
#     else
#         MONITOR=$m TRAY_POS=none polybar secondary &
#     fi
#   done
# fi

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log
polybar main | tee -a /tmp/polybar1.log & disown

echo "Bars launched..."
