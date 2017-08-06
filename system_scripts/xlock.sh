#!/bin/bash

# i3lock - improved screen locker

# Based on Remedan && adapted by OldGaro

# Keybing on i3 config that calls script. PS: dont forget to chmod u+x the script!
# bindsym $mod+c exec ~/.i3/i3lock.sh

# Set wallpaper path
WALL=screenlock.png

# Mute sound after locking session
pactl set-sink-mute 0 toggle

# Locks Session using i3lock with arguments: -f (show-failed-attempts) -n (Don't fork after starting) -i (image=path)
i3lock -f -n -i "$WALL"

# Unmute sound once i3lock successfully unlocks
pactl set-sink-mute 0 toggle

# AMIXER USERS

# # checks if sound is on or off
# SOUND=$(amixer sget Master | awk -F"[][]" '/Front Left.*%/ { print $4 }')
#
# # Mute sound after locking session
# amixer -q set Master mute
#
# # Unmute sound once i3lock successfully unlocks
# if [ $SOUND = "on" ]; then
#     amixer -q set Master unmute;
# fi

# Pause both Spotify and MPC
# playerctl -p spotify pause
# MPC_STATE=$(mpc | sed -n '2p' | cut -d "[" -f2 | cut -d "]" -f1)
# if [[ $MPC_STATE == "playing" ]]; then
            # mpc pause
        # fi
