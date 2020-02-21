setxkbmap us -option caps:escape
xrandr --output DP2-2 --right-of eDP1
xbindkeys
feh --bg-scale Pictures/cozy.jpg &
xrdb /home/elkasitu/.Xresources
dunst &
udiskie &
xsetroot -cursor_name left_ptr &
redshift -P -O 3500
exec bspwm
