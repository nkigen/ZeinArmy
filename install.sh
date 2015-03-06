#!/bin/bash
#(2015)nelson kigen<nellyk89@gmail.com>


INSTALL_PREFIX='/usr/local/bin'
TO_INSTALL='scripts/*'



main(){
	if [ ! "$1"="" ]; then
		sudo cp -r $TO_INSTALL $INSTALL_PREFIX
	else
		cp -r $TO_INSTALL $1
	fi

}
main "$@"
