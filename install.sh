#!/bin/bash
#----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 43):
# <nellyk89@gmail.com> wrote this file.  As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return.   nelson kigen
# ----------------------------------------------------------------------------

INSTALL_PREFIX='/usr/local/bin'
TO_INSTALL='scripts/*'
TMP_DIR="/tmp/zeinarmy"
DEPS=(
'git'
'aria2c'
)

check_version(){
	.
}

prepend(){
	echo "$1" | cat - $2 > .zatemp && mv .zatemp $2
}

install_zeinarmy(){
	echo "installing zeinarmy to "${INSTALL_PREFIX}
	sudo cp -r $TO_INSTALL $INSTALL_PREFIX
	sudo mkdir -p /etc/zeinarmy
	#prepend "CONFIG_DIR=/etc/zeinarmy" $(readlink -f config)
	sudo cp -r config /etc/zeinarmy
}

#Currently only deps for debian and ubuntu based systems are supported
install_deps(){
	source /etc/lsb-release
	sudo add-apt-repository "deb http://some-repo/ubuntu $DISTRIB_CODENAME main"
	if [ "r"$DISTRIB_CODENAME = "r" ]; then
		echo "Deps could not be installed" && exit 1
	elif [ $DISTRIB_CODENAME = "debian" ]; then
		
	fi

}
main(){
	if [ "r""$1" = "r" ]; then
		if [ "r""$1" = "r" ]; then
			install_zeinarmy
		else
			install_deps
			install_zeinarmy
		fi
	else
		echo "installing zeinarmy to ""$1"
		mkdir -p $1
		cp -r config $1
		cp -r $TO_INSTALL $1
	fi
}
main "$@"
