# .bash_profile
# init file for login shells
#

# Run ~/.bashrc like a normal shell
if [ -f ~/.bashrc ]
then
	 source ~/.bashrc
fi

# Disable caps lock on x sessions
setxkbmap -option ctrl:nocaps 2>/dev/null

# tried using fbterm but it sucked
#fbterm

# Stallmanu-san wisdom
#rmsfortune
# I removed it because RVM requires every session that uses ruby to use
# a login shell

# also, to make rvm work
source ~/.profile

# RVM (ruby) stuff
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 
export PATH=$PATH:$HOME/.rvm/bin         

# my default ruby version
rvm use 2.0.0 >/dev/null

# should I really set this command on every bash session?
#cpufreq-selector -g powersave
# check with cpufreq-info
