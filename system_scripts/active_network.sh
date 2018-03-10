#!/usr/bin/env bash

CONNECTED_WIFI=$(iwgetid | awk '{print $2}' | sed 's/ESSID://')  

WIFI_OUTPUT=""

if [[ $CONNECTED_WIFI == "\"TP-LINK_7ADF_5G\"" ]]; then
    WIFI_OUTPUT='<span font_desc="Material Icons 12" rise="-15000"></span>';
elif [[ $CONNECTED_WIFI == *"Infectious"* ]]; then
    WIFI_OUTPUT='<span font_desc="Material Icons 12" rise="-15000"></span>';
elif [[ $CONNECTED_WIFI == "\"Tenant Guests\"" ]]; then
    WIFI_OUTPUT="";
else
    WIFI_OUTPUT="";
fi

ETH_OUTPUT=""

ETH_BUF=$(ip route | grep default | head -n1 | grep en)

if [ ${#ETH_BUF} -gt 0 ]; then
    ETH_OUTPUT="<span font_desc='Font Awesome 10' rise='-12000'></span>"
fi

echo "$WIFI_OUTPUT$ETH_OUTPUT"
