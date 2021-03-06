#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

# modified version of https://github.com/dastorm/volume-notification-dunst
# it uses dunstify, ditches pulseaudio (ALSA is patrician) and makes the volume bar shorter

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    volume=`get_volume`
if [ "$volume" = "0" ]; then
        icon_name="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-muted.svg"
dunstify "$volume""      " -i "$icon_name" -t 2000 -h int:value:"$volume" -h string:synchronous:"─" --replace=555
    else
	if [  "$volume" -lt "10" ]; then
	     icon_name="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-low.svg"
dunstify "$volume""     " -i "$icon_name" --replace=555 -t 2000
    else
        if [ "$volume" -lt "30" ]; then
            icon_name="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-low.svg"
        else
            if [ "$volume" -lt "70" ]; then
                icon_name="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-medium.svg"
            else
                icon_name="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-high.svg"
            fi
        fi
    fi
fi
# Make the bar with the special character ─ (it's not dash -)
# https://en.wikipedia.org/wiki/Box-drawing_character
bar=$(seq -s "─" $(($volume/10)) | sed 's/[0-9]//g')
# Send the notification
dunstify "$volume""     ""$bar" -i "$icon_name" -t 2000 -h int:value:"$volume" -h string:synchronous:"$bar" --replace=555

}

case $1 in
    up)
	# Set the volume on (if it was muted)
	amixer set Master on > /dev/null
	# Up the volume (+ 5%)
	amixer sset Master 5%+ > /dev/null
	send_notification
	;;
    down)
	amixer set Master on > /dev/null
	amixer sset Master 5%- > /dev/null
	send_notification
	;;
    mute)
    	# Toggle mute
	amixer set Master toggle > /dev/null
	if is_mute ; then
dunstify -i "/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-muted.svg" --replace=555 -u normal "Mute" -t 2000
	else
	    send_notification
	fi
	;;
esac
