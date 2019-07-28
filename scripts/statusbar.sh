#!/usr/bin/env bash
# TODO: use case statements kek

function get_vol() {
    # gets the volume level from amixer
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function get_mute {
    # checks whether the current mixer is muted or not
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function get_cpu() {
    # gets the current CPU usage from top
    # /!\ only works on systems where top -v returns procps-ng
    # /!\ drops the floating point because bash sucks at floating point calculations without bc
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' | cut -d '.' -f 1
}

function get_mem() {
    # gets the current RAM usage
    free -m | awk 'NR==2{printf "%d", $3*100/$2}'
}

function _get_disk() {
    # gets the current disk usage for the specified mountpoint
    # $1 = the mountpoint to parse
    df -h | grep "$1" | awk '{printf "%s", $5}' | cut -d '%' -f 1
}

function get_root() {
    # $ is required otherwise it will match every single mountpoint
    _get_disk '/$'
}

function get_home() {
    _get_disk '/home'
}

function get_date() {
    date +"%a %b %d %H:%M:%S"
}

function get_ac() {
    cat /sys/class/power_supply/AC/online > /dev/null
}

function get_bat() {
    cat /sys/class/power_supply/BAT0/capacity
}

function _get_lan_if() {
    ip link show | grep enp | cut -d ':' -f 2 | cut -d ' ' -f 2
}

function _get_wlan_if() {
    ip link show | grep wlp | cut -d ':' -f 2 | cut -d ' ' -f 2
}

function get_wlan_info() {
    if=`_get_wlan_if`
    iwconfig $if
}

function get_wlan_ssid() {
    # $1 is the general information from which the SSID will be parsed
    echo $1 | grep ESSID | cut -d ':' -f 2 | cut -d '"' -f 2
}

function _blink() {
    # this function will make the chosen text "blink" every tick
    # $1 is the text in question
    # $2 is the color in which the text should blink, $fgcolor by default
    if [ "$blinked" -eq "0" ]; then
        if [ "$2" = "" ]; then
            status+=$1
        else
            status+="^fg($2)$1^fg($fgcolor) "
        fi
        blinked=1
    else
        status+="^fg($bgcolor)$1^fg($fgcolor) "
        blinked=0
    fi
}

function _display_percent() {
    # display a percentage with color stages
    # $1 is the value to display
    # $2 is the icon name or a string
    img_path="$HOME/.xbm/$2.xbm"
    if [ -e "$img_path" ]; then
        status+="^i($img_path) "
    else
        status+="$2 "
    fi
    if [ "$1" -lt "25" ]; then
        status+="^fg(green)"
    else
        if [ "$1" -lt "50" ]; then
            status+="^fg($fgcolor)"
        else
            if [ "$1" -lt "75" ]; then
                status+="^fg(yellow)"
            else
                status+="^fg(red)"
            fi
        fi
    fi
    status+="$1%^fg($fgcolor) "
}

function display_vol {
    # makes use of get_vol and get_mute to dynamically display the mixer status
    if get_mute ; then
        status+="^i($HOME/.xbm/volume0.xbm) "
    else
        vol=`get_vol`
        if [ "$vol" -lt "25" ]; then
            status+="^i($HOME/.xbm/volume25.xbm) $vol% "
        else
            if [ "$vol" -lt "50" ]; then
                status+="^i($HOME/.xbm/volume50.xbm) $vol% "
            else
                if [ "$vol" -lt "75" ]; then
                    status+="^i($HOME/.xbm/volume75.xbm) $vol% "
                else
                    status+="^i($HOME/.xbm/volume100.xbm) $vol% "
                fi
            fi
        fi
    fi
}

function display_cpu() {
    cpu=`get_cpu`
    _display_percent $cpu 'cpu'
}

function display_mem() {
    mem=`get_mem`
    _display_percent $mem 'mem'
}

function display_root() {
    root=`get_root`
    _display_percent $root '/: '
}

function display_home() {
    home=`get_home`
    _display_percent $home '/home: '
}

function display_date() {
    date=`get_date`
    status+="^i($HOME/.xbm/clock.xbm) $date  "
}

function display_power() {
    # display both AC and battery status
    if get_ac ; then
        status+="^fg(yellow)^i($HOME/.xbm/ac_01.xbm) AC^fg($fgcolor) "
    fi
    bat=`get_bat`
    if [ "$bat" -lt "10" ]; then
        _blink "^i($HOME/.xbm/battery10.xbm) $bat%" "red"
    else
        if [ "$bat" -lt "20" ]; then
            status+="^i($HOME/.xbm/battery20.xbm) $bat% "
        else
            if [ "$bat" -lt "30" ]; then
                status+="^i($HOME/.xbm/battery30.xbm) $bat% "
            else
                if [ "$bat" -lt "40" ]; then
                    status+="^i($HOME/.xbm/battery40.xbm) $bat% "
                else
                    if [ "$bat" -lt "50" ]; then
                        status+="^i($HOME/.xbm/battery50.xbm) $bat% "
                    else
                        if [ "$bat" -lt "60" ]; then
                            status+="^i($HOME/.xbm/battery60.xbm) $bat% "
                        else
                            if [ "$bat" -lt "70" ]; then
                                status+="^i($HOME/.xbm/battery70.xbm) $bat% "
                            else
                                if [ "$bat" -lt "80" ]; then
                                    status+="^i($HOME/.xbm/battery80.xbm) $bat% "
                                else
                                    status+="^fg(green)^i($HOME/.xbm/battery90.xbm) $bat%^fg($fgcolor) "
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        fi
    fi
}

function display_all() {
    # calls all display_* functions to form the status bar
    status=""
    display_power
    display_vol
    display_cpu
    display_mem
    display_root
    display_home
    display_date
    echo $status
}

function _get_resolution_width() {
    xrandr --query | awk 'NR==2{printf "%s", $4}' | cut -d 'x' -f 1
}

# Set dzen2 parameters
width=640
height=23
# TODO: Replace hard-coded value for xrandr
xmax=`_get_resolution_width`
xpos=$((xmax - width))
ypos=0
bgcolor="#222222"
fgcolor="#bbbbbb"
font="-*-iosevka-medium-r-*-*-11-*-*-*-*-*-*-*"

parameters=" -x $xpos -y $ypos -w $width -h $height"
parameters+=" -fn $font"
parameters+=" -ta r -bg $bgcolor -fg $fgcolor"
parameters+=" -title-name dzenbar"

# Execution
pkill dzen2
# for blinking effect
blinked=0
while sleep 0.8;
do
    display_all
done | dzen2 $parameters &
