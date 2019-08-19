#!/bin/bash

STATE=$1

if [ "_$STATE" == "_on" ]; then
	xrandr --auto --output DP-2-3 --mode 1920x1080 --left-of eDP-1
	xrandr --auto --output DP-2-1 --mode 2560x1440 --left-of DP-2-3
	xrandr --auto --output eDP-1 --off
else
	xrandr --auto --output eDP-1 --mode 1366x768
	xrandr --auto --output DP-2-1 --off
	xrandr --auto --output DP-2-3 --off
fi
