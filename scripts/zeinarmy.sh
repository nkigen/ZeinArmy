#!/bin/bash
#(2015) nelson kigen<nellyk89@gmail.com>

#set -x

CMD_DOWNLOAD="dl"
CMD_OPEN="open"
ARIA2_CONCURRENT_CONNECTIONS=8

#Checks if a command is available
##TODO:use command -v instead of hash
is_cmd(){
	hash "$@" &>/dev/null
}

#Downloads a url. First checks if aria2 is available. If not it uses wget or curl
download_url(){
	URL=$2
	OUTPUT_NAME=$3
	is_cmd "aria2c"
	if [ "$?" -eq 0 ];then
		echo "Using aria2 with "${ARIA2_CONCURRENT_CONNECTIONS}" concurrent connections. enjoy!"
		if [ ! -z ${OUTPUT_NAME} ]; then
			aria2c -x ${ARIA2_CONCURRENT_CONNECTIONS} ${URL} -o ${OUTPUT_NAME}
		else
			aria2c -x ${ARIA2_CONCURRENT_CONNECTIONS} ${URL}
		fi	

	else
		echo "You should consider installing aria2c, its way faster as it supports concurrent downloads"
		is_cmd "wget"
		if [ "$?" -eq 0 ];then
			echo "using wget\n"
		if [ ! -z ${OUTPUT_NAME} ]; then
			wget ${URL} -O ${OUTPUT_NAME}
		else
			wget ${URL}
		fi	
		else
			echo "wget absent"
		fi
	fi
}

#TODO: Support passing additional parameters 
default_open(){

	PARAM="$1"
	is_cmd "xdg-open"
	if [ "$?" -eq 0 ];then
		xdg-open ${PARAM} && return 0
	fi
	is_cmd "gnome-open"
	if [ "$?" -eq 0 ];then
		gnome-open ${PARAM} && return 0
	fi
	is_cmd "kde-open"
	if [ "$?" -eq 0 ];then
		kde-open ${PARAM} && return 0
	fi
}

fetch_cmd(){
	if [ "$1"=${CMD_DOWNLOAD} ];then
		export CURR_CMD="download_url"
	elif [ "$1"=${CMD_OPEN} ]; then
		export CURR_CMD="default_open"
	fi
}

main(){
	fetch_cmd "$@"
	${CURR_CMD} "$@"
}

main "$@"
