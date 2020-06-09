setxkbmap us -option caps:none
xrandr --output DP-2-2 --same-as eDP-1
xrandr --output DP-2-3 --right-of DP-2-2
xbindkeys
feh --bg-scale Pictures/cozy.jpg &
xrdb /home/elkasitu/.Xresources
dunst &
udiskie &
xsetroot -cursor_name left_ptr &
exec bspwm
