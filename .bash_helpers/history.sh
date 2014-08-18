# This file has functions that handles the bash history.
# It is normally sourced by `.bashrc`.
#
# Has a lot of functionality accumulated over the years.
#
# NOTE: For this file to work just fine, it has to be the
#       LAST file sourced on your `.bashrc`!
#
# EXPLANATION
#
# Bash has it's own way of dealing with the history - it saves
# all commands typed on a file `~/.bash_history`, right after
# the command is executed.
#
# That works fine, but when there are multiple shells running
# at the same time, they each get their turn to write to that
# file.
#
# When they all exit at the same time (like when closing a
# terminal with many tabs, or when the computer is powered
# off) they all try to write there at the same time,
# creating a race condition which, unfortunately, clears
# the whole history file.
#
# It has happened to me a few times over the years and
# I got super pissed. So, the following commands are a way to
# make it never happen again.
#
# First, we have a back up file, `~/.bash_history.bkp`.
# Before each command gets executed, we check to see if the
# main history file was cleared, comparing it with the backup.
# After this, we write the command to the main history file,
# making a backup afterwards.
# Finally, the command gets executed.
#
# Aside from all that, I like my history to be complete - having
# a date and time timestamp indicating when I ran those commands.
#
# Besides that, I'm used to have several terminals open at the
# same time. So I also attach the PID of the current shell,
# so when I grep the file it gives me some context.
#
# I do all this on a separate file, `~/.BASH_HISTORY`.

# Append to the history file, don't overwrite
shopt -s histappend

# Don't put duplicate lines in the history
# or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# For infinite history file, unset those
export HISTSIZE=
export HISTFILESIZE=

# This is my custom history file, where I keep timestamps and
# the PID of the process running a command
HISTORY_FILE="$HOME/.BASH_HISTORY"

# Sometimes my ~/.bash_history file was deleted and I couldn't
# figure out why.
#
# Searching led me to this page:
# <https://bbs.archlinux.org/viewtopic.php?id=150992>
# which tells it's a Bash problem, occurring when multiple
# shells die at the same time (like resetting computer or
# suddenly killing X).
#
# So I'll handle myself the history, along with Bash's .bash_history.
# I don't care when it's gets reset because my file won't.

# This function will be executed right before any command inserted.
preexec() {
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

	# Saving backup file.
	# (the \ is for running cp without recurring to aliases)
	\cp ~/.bash_history ~/.bash_history.bkp

	# Appending to the old .bash_history
	history -a

	# My new format to append to my new file:
	#
	# DATE, TIME, SHELL PID, HISTORY COMMAND COUNT, COMMAND
	#
	# each separated with one space (except COMMAND, that has two before)
	echo `date +'%y-%m-%d %R:%S'` $$ " $@" >> "$HISTORY_FILE"

	# I used to have this, but no need since right
	# below we send the current command as argument to `preexec`.
	#history | tail -n 1 | xargs -0 echo -n `date +'%y-%m-%d %R:%S'` $$ >> "$HISTORY_FILE"
}

# This sets up a custom `preexec` function to be
# executed before any command is executed.
#
# Source: http://superuser.com/a/175802
preexec_invoke_exec () {
	# Do nothing if completing
	[ -n "$COMP_LINE" ] && return

	# Don't cause a preexec for $PROMPT_COMMAND
	[ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return

	# The only caveat is that when we run a command
	# starting with space, bash's history ignores it
	# but we don't!
	# How can I know if the user-typed command starts
	# with space if the $BASH_COMMAND strips all leading
	# spaces?

	# # If the command starts with space, don't run `preexec`
	# local STARTS_SPACE="^ +[^ ]+"
	# [[ "$BASH_COMMAND" =~ $STARTS_SPACE ]] && echo HAUHUAHAHUAH

	# Gets the current command and send as an
	# argument to the `preexec` function.
	local this_command=`history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g"`;
	preexec "$this_command"
}
trap 'preexec_invoke_exec' DEBUG

