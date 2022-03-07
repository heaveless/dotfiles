#!/bin/bash

LANGUAGE="en_US"
app_name="spotify"
current_sink_num=
sink_num_check=
app_name_check=
is_increase=$1

pactl list sink-inputs |while read line; do
  sink_num_check=$(echo "$line" |sed -rn 's/^Sink Input #(.*)/\1/p')
  if [ "$sink_num_check" != "" ]; then
    current_sink_num="$sink_num_check"
  else
    app_name_check=$(echo "$line" |sed -rn 's/application.name = "([^"]*)"/\1/p')
    if [ "$app_name_check" = "$app_name" ]; then
      if [ "$is_increase" = "up" ]; then
        pactl set-sink-input-volume "$current_sink_num" +10%
      fi

      if [ "$is_increase" = "down" ]; then
        pactl set-sink-input-volume "$current_sink_num" -10%
      fi

      if [ "$is_increase" = "mute" ]; then
        pactl set-sink-input-volume "$current_sink_num" toggle
      fi

      if [ "$is_increase" = "play" ]; then
        pactl set-sink-input-volume "$current_sink_num" -10%
      fi

      if [ "$is_increase" = "stop" ]; then
        pactl set-sink-input-volume "$current_sink_num" -10%
      fi
      
      if [ "$is_increase" = "prev" ]; then
        pactl set-sink-input-volume "$current_sink_num" -10%
      fi

      if [ "$is_increase" = "next" ]; then
        pactl set-sink-input-volume "$current_sink_num" -10%
      fi
    fi
  fi
done
