# This file contains specific helpers for Debian
# Don't `source` it under other distros!
#
# For more info check `~/.bashrc`


# This works on Ubuntu/Debian (not on Arch Linux)
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'

# If you're into a `chroot`
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Debian Packager-related stuff

# My public GPG key
# Source:
# http://alexdantas.net/pgp
export GPG_PUB="AAF77239"

# Package maintainer information
export DEBFULLNAME="Alexandre Dantas"
export DEBEMAIL="eu@alexdantas.net"

# Quilt is the thing that allows to
# create patches for Debian packages
export QUILT_PATCHES=debian/patches
export QUILT_DIFF_ARGS="--no-timestamps --no-index -pab"
export QUILT_REFRESH_ARGS="--no-timestamps --no-index -pab"

# All lintian warnings, errors, etc
alias debuild='debuild --lintian-opts --info --display-info --pedantic --show-overrides --checksums --display-experimental --color=always'

alias uscan='uscan --verbose --report'


