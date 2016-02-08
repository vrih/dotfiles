if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xrdb ~/.Xresources

setxkbmap -layout gb

start-pulseaudio-x11

xmodmap -e "keycode 133 = Control_L"
xmodmap -e "keycode 37 = Super_L"
xmodmap -e "remove control = Super_L"
xmodmap -e "remove mod4 = Control_L"
xmodmap -e "add control = Control_L"


xrandr --output eDP1 --primary --dpi 239
>> /dev/null which nm-applet && nm-applet &

xautolock -time 5 -locker i3lock -notify 30 -i /usr/share/wallpaper/screenlock.png -e &

redshift-gtk &

exec i3
#true
