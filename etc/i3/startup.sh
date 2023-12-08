#!/bin/sh

# Call things here that are useful to the specific machine... in this example,
# we set up the monitors and set our background

# Don't actually do any of the below, edit this script to do what's needed.
exit 0

# Set up our monitors
xrandr \
  --output DP-4 --auto \
  --output HDMI-0 --right-of DP-4 --auto --rotate left \
  --output DP-1-3 --left-of DP-4 --auto
xset s 36000
xset dpms 0 0 36000

# Set our background
feh --bg-scale ~/media/images/wallpaper/forest-butterflies.jpeg

# Start picom, an X11 compositor
# https://github.com/yshui/picom
picom -f &
