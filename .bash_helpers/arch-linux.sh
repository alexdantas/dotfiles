# This file contains specific helpers for Arch Linux
# Don't `source` it under other distros!
#
# For more info check `~/.bashrc`


# Yaourt falls back to Pacman, so no need
# to distinguish them both.
#
# Also, won't reinstall packages
alias pacman='yaourt --needed'

# Updating EVERYTHING with no confirmation
alias pacman-update="sudo yaourt -Syyu --devel --aur --noconfirm"


# Arch packager helper
# Erases everything temporary under the current directory
# (stuff generated with `makepkg`, `mkaurball` and `updpkgsums`)
#
# Note: It takes care to only delete things if there's a
#       `PKGBUILD` on the current directory.
function pkgbuild-clean() {
	name=`basename $PWD`

	if [ ! -f "PKGBUILD" ]
	then
		echo "Error: No 'PKGBUILD' on the current directory"
		echo "       Won't delete anything"
		return -1
	fi

	rm -fv  ./*.tar.gz ./*.tar.xz
	rm -rfv ./pkg ./src
}



# This works on Arch Linux (not on Ubuntu/Debian)
export LESSOPEN='| /usr/bin/src-hilite-lesspipe.sh %s'


