# ~/.bashrc
# Main configuration file for non-login shells.
#
# For examples, see
# `/usr/share/doc/bash/examples/startup-files` (in the package bash-doc)

# Avoid re-reading this file unless explicitly asked.
# To re-read, use the alias `resource`.
if [ "$BASHRC_READ" != yes ]; then
BASHRC_READ=yes

#echo "Reading .bashrc";

# Separate file for alias definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# If not running interactively,
# don't do anything
[ -z "$PS1" ] && return

# Configure shell options.
# Check all settings bwith `shopt`
shopt -s histappend   # append to the history file, don't overwrite
shopt -s checkwinsize # check window size after each command, updating LINES and COLUMNS

# Don't put duplicate lines in the history
# or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# Infinite history file
export HISTSIZE=
export HISTFILESIZE=

# Advanced History Management!
#
# Sometimes my ~/.bash_history file was deleted and I couldn't
# figure out why.
# Searching led me to this page https://bbs.archlinux.org/viewtopic.php?id=150992
# which tells it's a Bash problem, occurring when multiple
# shells die at the same time (like resetting computer or
# suddenly killing X).
#
# So I'll handle myself the history, along with Bash's .bash_history.
# I don't care when it's resetted because my file won't.
HISTORY_FILE="$HOME/.BASH_HISTORY"

# This function will be executed right before any command inserted.
prompt_command() {
	# Setting the title of the terminal as the current directory
	echo -ne "\033]0;${PWD}\a"

	# Checking if the .bash_history file was cleared.
	# If so, restoring to the backup
	touch ~/.bash_history ~/.bash_history.bkp

	new_count=`wc -l ~/.bash_history     | cut -d ' ' -f 1`
	bkp_count=`wc -l ~/.bash_history.bkp | cut -d ' ' -f 1`

	if (( $bkp_count > $new_count ))
	then
		# Woops, the .bash_history was cleared somehow!
		cat ~/.bash_history.bkp ~/.bash_history > ~/.bash_history
	fi

	# Saving backup
	cp ~/.bash_history ~/.bash_history.bkp

	# Appending to the old .bash_history
	history -a

	# My new format to append to my new file
	# DATE, TIME, SHELL PID, HISTORY COMMAND COUNT, COMMAND
	history | tail -n 1 | xargs -0 echo -n `date +'%y-%m-%d %R:%S'` $$ >> "$HISTORY_FILE"
}

# This will force the previous function to be executed
# after every command I do
export PROMPT_COMMAND=prompt_command

# Disable Ctrl+S and Ctrl+Q terminal flow input
# (now Ctrl+s does forward incremental search on history)
stty -ixon

# If you're into a `chroot`
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Allows fancy colored prompts according to terminal.
# Also, `mrxvt` can't display unicode, fallback to something else
case "$TERM" in
	xterm-color)    color_prompt=yes;;
	xterm-256color) color_prompt=yes;;
#	rxvt)           export LC_CTYPE=en_US.iso-8859-1; export LANG=en_US.iso-8859-1;;
esac

# This pretty much cancels the thing right above, right?
# I use this to allow pretty colored output on certain programs.
#export TERM=xterm-256color

# Forcing color prompt on everything.
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then

	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Separate file for definitions of several colors.
# These are the definition of handy aliases for colors.
if [ -f ~/.bash_colors ]; then
    source ~/.bash_colors
fi

# Enable color support of ls and also add handy aliases.
# My custom ls colors are on "~/.dircolors"
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto --time-style=long-iso'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Awesome Bash Prompt `PS1`
#
# Check:
# http://maketecheasier.com/8-useful-and-interesting-bash-prompts/2009/09/04

PS1="\
\[$BICyan\]\W\
\$(if [[ \$? == 0 ]];\
then echo \"\[$BGreen\]\";\
else echo \"\[$BRed\]\"; fi):\
\[$Color_Off\]"

# Enable programmable completion features
# (you don't need to enable this, if it's already enabled in `/etc/bash.bashrc`
# and `/etc/profile` sources `/etc/bash.bashrc`).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# My main home directory, was `/mnt/kure`
# If I ever change it, lets just do it here
export MAIN_HOME=~

## Paths

# PATH: To executable files
export PATH=$PATH:/usr/games             # Strangely it doesnt appear on Arch
export PATH=$PATH:$MAIN_HOME/bin         # kure's custom bin dir
export PATH=$PATH:/usr/bin/core_perl     # Arch Linux: core perl modules
export PATH=$PATH:~/.gem/ruby/2.1.0/bin  # Ruby gems (newest new new Ruby)
export PATH=$PATH:~/.gem/ruby/2.0.0/bin  # Ruby gems
export PATH=$PATH:/opt/jruby/bin         # Jruby Binaries

# Reset PATH
# PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/games
# export PATH

# MANPATH: To man pages
export MANPATH=$MANPATH:/usr/share/man
export MANPATH=$MANPATH:/usr/man
export MANPATH=$MANPATH:/usr/local/man
export MANPATH=$MANPATH:/usr/local/share/man
export MANPATH=$MANPATH:$MAIN_HOME/.rvm/man
export MANPATH=$MANPATH:$MAIN_HOME/.local/share/man

# CDPATH: Implicitly `cd` to directories listed here.
#
# `cd` will look for directories first on the current,
# then on `$MAIN_HOME`.
# Nice shortcut!
export CDPATH=".:$MAIN_HOME"

# Customizing colors for man pages
# See
# https://wiki.archlinux.org/index.php/Man_Page
#
# In my case, will use color definitions from my
# `.bash_colors`.
man() {
    env LESS_TERMCAP_mb=$(printf "$BGreen") \
        LESS_TERMCAP_md=$(printf "$BYellow") \
        LESS_TERMCAP_me=$(printf "$Color_Off") \
        LESS_TERMCAP_se=$(printf "$Color_Off") \
        LESS_TERMCAP_so=$(printf "$BCyan") \
        LESS_TERMCAP_ue=$(printf "$Color_Off") \
        LESS_TERMCAP_us=$(printf "$BRed") \
        man "$@"
}

# For mail programs
export MAIL=/var/spool/mail/$USER

# My new favorite editor, the great holy emacs.
# (flag to force textual version)
export EDITOR='emacs -nw'

export PAGER='less'
export VIEWER='less'

# For lynx colors
export LYNX_LSS=~/.lynx/lynx.lss

# Key shortcuts for the shell,
# check them out!
export INPUTRC=$MAIN_HOME/.inputrc

# # Are we on a X session?
# if [ -e "$XAUTHORITY" ]
# then
# 	# Do something naughty
# fi

# Debian Packager-related stuff
# Ignore it if you're not on it.
export GPG_PUB="B63CF56F"
export DEBFULLNAME="Alexandre Dantas"
export DEBEMAIL=alex.dantas92@gmail.com
export QUILT_PATCHES=debian/patches
export QUILT_DIFF_ARGS="--no-timestamps --no-index -pab"
export QUILT_REFRESH_ARGS="--no-timestamps --no-index -pab"

# For `bundle` gem to work correctly, installing gems on $HOME.
#export GEM_HOME=~/.gem/ruby/2.0.0

# Lots of things to make Ruby Version Manager work
# * commented stuff on `/etc/gemrc`, check it out
unset RUBYLIB
unset GEM_HOME


# Avoid re-reading this file unless explicitly asked
# (by the alias `resource`)
fi


