#!/usr/bin/env bash
# TODO: use case statements kek

# TODO: put this in another file and source it here
function _emojify() {
    echo "^fn(Font Awesome 5 Free Solid:size=10)$1^fn()"
}

emoji_mute=$(_emojify )
emoji_low_vol=$(_emojify )
emoji_mid_vol=$(_emojify )
emoji_hi_vol=$(_emojify )
emoji_cpu=$(_emojify )
emoji_ram=$(_emojify )
emoji_ac=$(_emojify )
emoji_bat_0=$(_emojify )
emoji_bat_1=$(_emojify )
emoji_bat_2=$(_emojify )
emoji_bat_3=$(_emojify )
emoji_bat_4=$(_emojify )
emoji_hdd=$(_emojify )
emoji_calendar=$(_emojify )
emoji_clock=$(_emojify )

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
    date +"%a %b %d"
}

function get_time() {
    date +"%H:%M:%S"
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
    if=$(_get_wlan_if)
    iwconfig "$if"
}

function get_wlan_ssid() {
    # $1 is the general information from which the SSID will be parsed
    echo "$1" | grep ESSID | cut -d ':' -f 2 | cut -d '"' -f 2
}

function get_active_wm_name() {
    # requires xdotool package
    xdotool getactivewindow getwindowname
}

function get_current_monitor() {
    bspc query -M -m focused
}

function get_current_mon_desktops() {
    m=$(get_current_monitor)
    echo "$m" | bspc query -D -m --names
}

function get_focused_desktop() {
    bspc query -D -d focused --names
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
    # $2 is a string (emoji, plain-text) to display before the information
    status+="$2 "
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
        status+="$emoji_mute "
    else
        vol=$(get_vol)
        if [ "$vol" -lt "33" ]; then
            status+="$emoji_low_vol $vol% "
        else
            if [ "$vol" -lt "66" ]; then
                status+="$emoji_mid_vol $vol% "
            else
                status+="$emoji_hi_vol $vol% "
            fi
        fi
    fi
}

function display_cpu() {
    cpu=$(get_cpu)
    _display_percent "$cpu" "$emoji_cpu"
}

function display_mem() {
    mem=$(get_mem)
    _display_percent "$mem" "$emoji_ram"
}

function display_root() {
    root=$(get_root)
    _display_percent "$root" "$emoji_hdd"
}

function display_home() {
    home=$(get_home)
    _display_percent "$home" "$emoji_hdd"
}

function display_date() {
    date=$(get_date)
    status+="$emoji_calendar $date  "
}

function display_time() {
    time=$(get_time)
    status+="$emoji_clock $time "
}

function display_power() {
    # display both AC and battery status
    if get_ac ; then
        status+="^fg(yellow)$emoji_ac AC^fg($fgcolor) "
    fi
    bat=$(get_bat)
    if [ "$bat" -lt "10" ]; then
        _blink "$emoji_bat_0 $bat%" "red"
    else
        if [ "$bat" -lt "30" ]; then
            status+="$emoji_bat_1 $bat% "
        else
            if [ "$bat" -lt "60" ]; then
                status+="$emoji_bat_2 $bat% "
            else
                if [ "$bat" -lt "90" ]; then
                    status+="$emoji_bat_3 $bat% "
                else
                    status+="$emoji_bat_4 $bat% "
                fi
            fi
        fi
    fi
}

function display_active_wm_name() {
    active_wm_name=$(get_active_wm_name)
    status+="^p(+50)$active_wm_name^p(_RIGHT)^p(-600)"
}

function display_cur_mon_desktops() {
    # TODO: do separately by subscribing to bspc to get instantaneous update
    status+="^p(_LEFT) "
    desktops=$(get_current_mon_desktops)
    focused=$(get_focused_desktop)
    for desktop in $desktops
    do
        if [ "$desktop" = "$focused" ]; then
            status+="^bg(red) ^fg(black)$desktop^fg() ^bg()"
        else
            status+=" $desktop "
        fi
    done
}

function display_all() {
    # calls all display_* functions to form the status bar
    status=""
    display_cur_mon_desktops
    display_active_wm_name
    display_power
    display_vol
    display_cpu
    display_mem
    display_root
    display_home
    display_date
    display_time
    echo "$status"
}

function _get_resolution_width() {
    xrandr --query | awk 'NR==2{printf "%s", $8}'
}

# Set dzen2 parameters
width=$(_get_resolution_width)
height=23
xpos=0
ypos=0
bgcolor="#222222"
fgcolor="#bbbbbb"
font="-*-iosevka-medium-*-*-*-*-*-*-*-*-*-*-*"

parameters="-x $xpos -y $ypos -w $width -h $height"
parameters+=" -fn $font"
parameters+=" -ta l -bg $bgcolor -fg $fgcolor"
parameters+=" -title-name dzenbar"

# Execution
pkill dzen2
# for blinking effect
blinked=0
while sleep 0.8;
do
    display_all
done | dzen2 $parameters &
