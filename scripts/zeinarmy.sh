#!/bin/bash
#----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 43):
# <nellyk89@gmail.com> wrote this file.  As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return.   nelson kigen
# ----------------------------------------------------------------------------

#set -x
#BEWARE the arrangement of these string matter!!!
UNCOMPRESS_EXTS=(
'tar'
'tar.gz'
'tar.xz'
'tar.bz2'
'zip'
'rar'
'tgz'
)

TMP_DIR="/tmp/"
#Checks if a command is available
##TODO:use command -v instead of hash

is_cmd(){
	hash "$@" &>/dev/null
}


#Add an alias to .bash_aliases file
add_alias(){
	echo "alias $1='$1'" >> ~/.bash_aliases
	echo "alias $1='$2' added to ~/.bash_aliases"
}

prepend(){
	echo "$1" | cat - $2 > ${TMP_DIR}.zatemp && mv ${TMP_DIR}.zatemp $2

}
#Add the beer-ware license on top of source file
beerware(){
	echo '#----------------------------------------------------------------------------
	# "THE BEER-WARE LICENSE" (Revision 43):
	# <nellyk89@gmail.com> wrote this file.  As long as you retain this notice you
	# can do whatever you want with this stuff. If we meet some day, and you think
	# this stuff is worth it, you can buy me a beer in return.   nelson kigen
	# ----------------------------------------------------------------------------' | cat - $1 > ${TMP_DIR}.zatemp && mv ${TMP_DIR}.zatemp $1

}

chmod_num(){
	ls -l ${@:2} | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) \
		*2^(8-i));if(k)printf("%0o ",k);print}' | cut -c1-3 
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

	PARAM="$2"
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

#Currently assumes there are no periods('.') upto the extensions (unwise I know but Im working on a solution)
uncompress(){
	FILE="$2"
	EXT=${FILE#*.}
	count=0
	while [ "x${UNCOMPRESS_EXTS[count]}" != "x" ]
	do
		if [[ $FILE == *.${UNCOMPRESS_EXTS[count]} ]];then
			export EXT=${UNCOMPRESS_EXTS[count]}
			break
		fi
		count=$(( $count + 1 ))
	done

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

#Convert image size
convert_size(){
	convert "$2" "$3" "$2"
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

version(){
	echo $VERSION
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
	elif [ "$1" = ${CMD_CONVERT} ]; then
		CURR_CMD="convert_size"
	elif [ "$1" = ${CMD_CHMOD_NUM} ]; then
		CURR_CMD="chmod_num"
	elif [ "$1" = ${CMD_ALIAS} ]; then
		CURR_CMD="add_alias"
	elif [ "$1" = ${CMD_BEERWARE} ]; then
		CURR_CMD="beerware"
	elif [ "$1" = ${CMD_VERSION} ]; then
		CURR_CMD="version"
	elif [ "$1" = ${CMD_PREPEND} ]; then
		CURR_CMD="prepend"
	fi
	export CURR_CMD
}

main(){
	source /etc/zeinarmy/config
	fetch_cmd "$@"
	#echo `basename $0`":current command "${CURR_CMD}
	${CURR_CMD} "$@"

}

main "$@"
