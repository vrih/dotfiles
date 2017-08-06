#!/bin/sh

OUTPUT_PORT="alsa_output.pci-0000_00_1f.3.analog-stereo"
OUTPUT_PORT2="alsa_output.usb-Plantronics_Plantronics_.Audio_655_DSP-00.analog-stereo"

pactl list


if [ "$1" = "up" ]; then
    echo "volume up"
    pactl set-sink-volume $OUTPUT_PORT +5%
    pactl set-sink-volume $OUTPUT_PORT2 +5%
elif [ "$1" = "down" ]; then
    echo "volume down"
    pactl set-sink-volume $OUTPUT_PORT -5%
    pactl set-sink-volume $OUTPUT_PORT2 -5%
else
    pactl set-sink-mute $OUTPUT_PORT toggle
    pactl set-sink-mute $OUTPUT_PORT2 toggle
fi

pkill -RTMIN+10 i3blocks

exit 0
