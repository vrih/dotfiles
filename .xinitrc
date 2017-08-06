if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi


#compton -b -c 

xrdb ~/.Xresources

setxkbmap -layout gb
ibus-daemon &

pulseaudio --start

xmodmap ~/.Xmodmap

xautolock -time 5 -locker i3lock -notify 30 -i /home/daniel/wallpaper.png -e &

xrandr --output eDP1 --primary
dropbox &

redshift-gtk &

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

exec i3

