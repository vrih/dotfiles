#!/bin/sh

OUTPUT_PORT=$(pacmd list-sinks | grep -B1 'alsa_output.platform-bdw-rt5677.analog-stereo' | grep -o 'index:.*' | awk '{ print $2 }' )
DEVICE='alsa_output.pci-0000_00_14.2.analog-stereo'
ACTIVE_SINK=$(pacmd list-sinks | grep 'active port' | grep 'analog' | awk '{ print $3 }' | head -n1)

echo $ACTIVE_SINK

if [ "$ACTIVE_SINK" = "<analog-output-headphones>" ]; then
	echo "[*] Enabling all analog output on $DEVICE."
	pactl set-sink-port $OUTPUT_PORT analog-output-speaker > /dev/null
        amixer -c 0 cset name='Headset Mic Switch' off
#        alsaucm -c bdw-rt5677 set _verb HiFi set _disdev Mic
else
	echo "[*] Enabling headphones only on $DEVICE."
	pactl set-sink-port $OUTPUT_PORT analog-output-headphones > /dev/null
        amixer -c 0 cset name='Headset Mic Switch' on
#        alsaucm -c bdw-rt5677 set _verb HiFi set _enadev Mic
fi

exit 0
