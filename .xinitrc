setxkbmap us -option caps:escape
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
xrandr --output DP-1-2-2 --right-of eDP-1-1
xbindkeys
feh --bg-scale Pictures/cozy.jpg &
xrdb /home/elkasitu/.Xresources
dunst &
xsetroot -cursor_name left_ptr &
exec bspwm
