#!/bin/bash
#----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <nellyk89@gmail.com> wrote this file.  As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return.   Poul-Henning Kamp
# ----------------------------------------------------------------------------

INSTALL_PREFIX='/usr/local/bin'
TO_INSTALL='scripts/*'



check_version(){

}
main(){
	if [ "r""$1" = "r" ]; then
		echo "installing zeinarmy to "${INSTALL_PREFIX}
		sudo cp -r $TO_INSTALL $INSTALL_PREFIX
	else
		echo "installing zeinarmy to ""$1"
		cp -r $TO_INSTALL $1
	fi

}
main "$@"
