#!/bin/sh

# Toggle microphone

OUTPUT_PORT=$(pacmd list-sources | grep -B1 'alsa_input.pci'| grep -o 'index:.*' | awk '{ print $2 }' )
USB_PORT=$(pacmd list-sources | grep -B1 'alsa_input.usb' | grep -o 'index:.*' | awk '{print $2 }')

if [ $USB_PORT ]; then
    SINK_PORT=$USB_PORT
else
    SINK_PORT=$OUTPUT_PORT
fi

echo $SINK_PORT
    
# If USB headset is plugged in then treat that as source
pactl set-source-mute $SINK_PORT toggle;
    
pkill -RTMIN+10 i3blocks

exit 0
