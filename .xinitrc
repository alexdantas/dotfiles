#!/bin/sh
#
# xinitrc: The first file read by X when initializing
# Executed by `startx` and `xinit`

# Reading default variables for X apps
xrdb -merge ~/.Xdefaults

# For more keyboard stuff, check `~/.xmodmap`

# Resets all previous `setxkbmap` settings
setxkbmap -option

# Make Caps Lock act as a Super Key (Windows logo key)
setxkbmap -option caps:super

# Which Window Manager will I use when `initx`?
# Let's make it choose based on the argument.
# So `xinit awesome` would launch awesome and so on
case "$1" in
	openbox) exec openbox-session;;
	fluxbox) exec startfluxbox;;
	subtle)  exec subtle;;
	awesome) exec awesome;;
	dwm)     exec dwm;;
	wmii)    exec wmii;;

	# Default option - my beloved awesome
	*)       exec awesome;;
esac

