# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Avoid re-reading this file unless explicitly asked (by the alias 'resource')
if [ "$BASHRC_READ" != yes ]; then
BASHRC_READ=yes

#echo "Reading .bashrc";

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Configure shell options. Check all settings with 'shopt'
shopt -s histappend   # append to the history file, don't overwrite
shopt -s checkwinsize # check window size after each command, updating LINES and COLUMNS

# Don't put duplicate lines in the history or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# Infinite history file
export HISTSIZE=
export HISTFILESIZE=

# This will force the history file to be refreshed
# after each command
export PROMPT_COMMAND='history -a'

# Disable Ctrl+s and Ctrl+q terminal flow input
# (now Ctrl+s does forward incremental search on history)
stty -ixon

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
# also, mrxvt can't display unicode, let's fallback to something else
case "$TERM" in
	xterm-color)    color_prompt=yes;;
	xterm-256color) color_prompt=yes;;
	rxvt)           export LC_CTYPE=en_US.iso-8859-1; export LANG=en_US.iso-8859-1;;
esac

# This pretty much cancels the thing right above, right?
# I use this to allow pretty colored output on certain programs.
export TERM=xterm-256color

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
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
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Bash Prompt (PS1)
# This is my new awesome prompt. It's a constant work in progress and
# you can see it's development history below

PS1="\
\[$BICyan\]\W\
\$(if [[ \$? == 0 ]];\
then echo \"\[$BGreen\]\";\
else echo \"\[$BRed\]\"; fi):\
\[$Color_Off\]"

# OLD WAY< DEPRECATED
# # My custom prompt - depends on the user id passed to it
# customize_color_set() {

# 	# foreground colors
# 	red=$(tput setaf 1)
# 	green=$(tput setaf 2)
# 	yellow=$(tput setaf 3)
# 	blue=$(tput setaf 4)
# 	purple=$(tput setaf 5)
# 	cyan=$(tput setaf 6)
# 	bold=$(tput bold)
# 	reset=$(tput sgr0)
# 	# Identifiers:
# 	# \w full path of the current directory
# 	# \W last part of the current directory
# 	# \u current user

# 	# Prompt for the root user
# 	if [ $1 -eq 0 ]; then
# 		PS1="\[$red\]\u:\[$bold\]\[$red\]\W\[$reset\] $ "

# 	# For everyone else
# 	else
# 		PS1="\[$green\]\u:\[$bold\]\[$green\]\W\[$reset\] $ "
# 	fi
# }

# Nice sweet prompt, you should test it out!
#
# The only caveat is that it constantly needs to access the disk to
# get that information.
#
# http://maketecheasier.com/8-useful-and-interesting-bash-prompts/2009/09/04
#
#PS1="\[\033[1;37m\]$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\W'; fi)\[\033[1;37m\] \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]:)\"; else echo \"\[\033[01;31m\]:(\"; fi)\[\033[1;37m\] \[\033[1;37m\][\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g')f, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\]] $ \[\033[0m\]"

#
# export PS1='$(git branch &>/dev/null;\
# if [ $? -eq 0 ]; then \
#   echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
#   if [ "$?" -eq "0" ]; then \
#     # @4 - Clean repository - nothing to commit
#     echo "'$Green'"; \
#   else \
#     # @5 - Changes to working tree
#     echo "'$IRed'"; \
#   fi) |\$ "; \
#   # @2 - Prompt when not in GIT repo
# fi)\
# $(if [[ $? == 0 ]];\
# then echo "'$BGreen'";\
# else echo "'$BRed'"; fi):\
# '$BICyan'\W\
# '$Color_Off''


# Separate file for alias definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# My main home directory
# If I ever change it, lets just do it here
export MAIN_HOME=~

## Paths

# PATH: To executable files
export PATH=$PATH:$MAIN_HOME/bin         # kure's custom bin dir
export PATH=$PATH:$MAIN_HOME/sbt/bin     # temporary stuff for SCALA class
export PATH=$PATH:/opt/java/jre/bin      # Arch Linux: where I keep the jre
export PATH=$PATH:/usr/bin/core_perl     # Arch Linux: core perl modules
export PATH=$PATH:~/.gem/ruby/2.0.0/bin  # Ruby gems

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

# CDPATH: To implicitly cd to directories listed here
# cd will look for directories first on the current, then
# on $MAIN_HOME. Nice shortcut!
export CDPATH=".:$MAIN_HOME"

# Customizing colors for man pages
# See https://wiki.archlinux.org/index.php/Man_Page
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

# I used to have a console color scheme, but now I use mrxvt
#$MAIN_HOME/.console-colors/current

# Why is this here? What does it mean?
export INPUTRC=$MAIN_HOME/.inputrc

# Switching CapsLock by the Super Key (Windows logo key)
# If you wanna use extra keys, see '.xmodmap'
setxkbmap -option
setxkbmap -option caps:super

# Debian Packager-related stuff
# Ignore it if you're not on it.
export GPG_PUB="B63CF56F"
export DEBFULLNAME="Alexandre Dantas"
export DEBEMAIL=alex.dantas92@gmail.com
export QUILT_PATCHES=debian/patches
export QUILT_DIFF_ARGS="--no-timestamps --no-index -pab"
export QUILT_REFRESH_ARGS="--no-timestamps --no-index -pab"

# In Arch there's the plan9 specific apps.
# This way you can use their apps via `9 date`
# For a good reading, see `9 man 1 intro | less`
#source /etc/profile.d/plan9.sh

# For `bundle` gem to work correctly, installing gems on $HOME.
export GEM_HOME=~/.gem/ruby/2.0.0

# Avoid re-reading this file unless explicitly asked (by the alias 'resource')
fi
