#!/usr/bin/env bash

# Get system information from conky
generated_output() {
    DIR=$(dirname "$0")
    conky -c ${DIR}/conky.conf.lua
}

# Set dzen2 parameters
width=640
height=19
# TODO: Replaced hard-coded value for xrandr
xpos=1280
ypos=0
bgcolor="#222222"
fgcolor="#bbbbbb"
font="-*-iosevka-medium-r-*-*-12-*-*-*-*-*-*-*"

parameters=" -x $xpos -y $ypos -w $width -h $height"
parameters+=" -fn $font"
parameters+=" -ta r -bg $bgcolor -fg $fgcolor"
parameters+=" -title-name dzenbar"

# Execution
pkill dzen2
generated_output | dzen2 $parameters &
