#!/bin/bash
#(2015) nelson kigen<nellyk89@gmail.com>

#set -x

#Commands
CMD_DOWNLOAD="dl"
CMD_OPEN="open"
CMD_UNCOMPRESS="uc"
CMD_COMPRESS="c"
CMD_DUMP="d" #Dump all of a script output to a file


ARIA2_CONCURRENT_CONNECTIONS=8

UNCOMPRESS_EXTS=(
		'tar'
		'tar.gz'
		'tar.xz'
		'tar.bz2'
		'zip'
		'rar'
		'tgz'
		)

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

uncompress(){
FILE="$2"
EXT=${FILE#*.}

echo "FILE : "${FILE} " extension "$EXT
count=0
while [ "x${UNCOMPRESS_EXTS[count]}" != "x" ]
do
	if [[ ${UNCOMPRESS_EXTS[count]} == *"${EXT}" ]];then
		echo "found"
		break
	fi
	count=$(( $count + 1 ))
done

if [ $count -eq 0 ];then
	tar -xvf "$FILE"
elif [ $count -eq 1 ];then
	tar zxvf "$FILE"
elif [ $count -eq 2 ];then
	tar xvf "$FILE"
elif [ $count -eq 3 ];then
	tar xjvf "$FILE"
elif [ $count -eq 4 ];then
	unzip "$FILE"
elif [ $count -eq 5 ];then
	rar x "$FILE"
elif [ $count -eq 6 ];then
	tar zxvf "$FILE"
fi
}

#Currently only tar is used. SUpport for others in the next release
compress(){
   tar -zcvf "$2".tar.gz "$3" 
}

#Currently assumes full paths only
#TODO: Expand relative paths to full paths
dump(){
NUM_ARGS="$#"
if [ "$SHELL" = "/bin/bash" ]; then
	if [ $NUM_ARGS -eq 3 ]; then
		"$2" > "$3"  2>&1
	fi
fi	

}

fetch_cmd(){
	CURR_CMD=""
	if [ "$1" = ${CMD_DOWNLOAD} ];then
		CURR_CMD="download_url"
	elif [ "$1" = ${CMD_OPEN} ]; then
		CURR_CMD="default_open"
	elif [ "$1" = ${CMD_UNCOMPRESS} ]; then
		CURR_CMD="uncompress"
	elif [ "$1" = ${CMD_COMPRESS} ]; then
		CURR_CMD="compress"
	elif [ "$1" = ${CMD_DUMP} ]; then
		CURR_CMD="dump"
	fi
	export CURR_CMD
}

main(){
	fetch_cmd "$@"
	echo "current command "${CURR_CMD}
	${CURR_CMD} "$@"
}

main "$@"
