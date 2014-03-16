
# Reading default variables for X apps
xrdb -merge ~/.Xdefaults

# Disabling Caps Lock
setxkbmap -option ctrl:nocaps 2>/dev/null

# Making Caps Lock act as a Super Key (Windows logo key)
# If you wanna use extra keys, see `.xmodmap`.
setxkbmap -option
setxkbmap -option caps:super

# Which Window Manager will I use when `startx`?
#exec awesome
#exec subtle
