#!/bin/sh

OUTPUT_PORT=0

if [ "$1" = "up" ]; then
    echo "volume up"
    pactl set-sink-volume $OUTPUT_PORT +5%
elif [ "$1" = "down" ]; then
    echo "volume down"
    pactl set-sink-volume $OUTPUT_PORT -5%
else
    pactl set-sink-mute $OUTPUT_PORT toggle
fi

pkill -RTMIN+10 i3blocks

exit 0
