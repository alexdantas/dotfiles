# .bash_profile
# Init file for login shells

# Run ~/.bashrc like a normal shell
if [ -f ~/.bashrc ]
then
	 source ~/.bashrc
fi

# Tried using fbterm but it sucked

# Stallmanu-san wisdom
#rmsfortune

## Ruby Version Manager stuff
## Load RVM into a shell session *as a function*
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
#export PATH=$PATH:$HOME/.rvm/bin

## my default ruby version
#rvm use 2.0.0 >/dev/null

# should I really set this command on every bash session?
#cpufreq-selector -g powersave
# check with cpufreq-info

# Disabling the awful awful beeping on my
# new Toshiba laptop
setterm -blength 0
