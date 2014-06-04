# The first file read by X when initializing

# Reading default variables for X apps
xrdb -merge ~/.Xdefaults

# For more keyboard stuff, check `~/.xmodmap`

# Resets all previous `setxkbmap` settings
setxkbmap -option

# Make Caps Lock act as a Super Key (Windows logo key)
setxkbmap -option caps:super

# Which Window Manager will I use when `startx`?
#exec awesome
#exec subtle

