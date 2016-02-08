#!/bin/sh

DEVICE='alsa_output.pci-0000_00_14.2.analog-stereo'
ACTIVE_SINK=$(pacmd list-sinks | grep 'active port' | grep 'analog' | awk '{ print $3 }' | head -n1)

echo $ACTIVE_SINK

if [ "$ACTIVE_SINK" = "<analog-output-headphones>" ]; then
	echo "[*] Enabling all analog output on $DEVICE."
	pactl set-sink-port 1 analog-output-speaker > /dev/null
else
	echo "[*] Enabling headphones only on $DEVICE."
	pactl set-sink-port 1 analog-output-headphones > /dev/null
fi

# send signal to i3blocks
pkill -RTMIN+11 i3blocks

exit 0
