#!/bin/sh

TOUCHPAD_ID=$(xinput | grep 'Touchpad' | grep -o 'id=[0-9]*' | awk -F= '{ print $2 }' )
TOUCHPAD_STATE=$(xinput list-props 9 | grep 'Device Enabled' | awk '{print $4}')

if [ "$TOUCHPAD_STATE" = "1" ]; then
    echo "[*] Disabling Touchpad."
    xinput disable $TOUCHPAD_ID
else
    echo "[*] Enabling Touchpad."
    xinput enable $TOUCHPAD_ID
fi

exit 0
