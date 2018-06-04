#! /bin/bash
#
#
#	Attribute codes:
#	00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
#	
#	Text color codes:
#	30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
#	
#	Background color codes:
#	40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
#	
# Functions:
Usage() {
	clear
	printf "\n\n\n"
	if [ "$1" != "" ]; then
		printf "\e[01;33;44m"
		printf "\n%s: ERROR:  %s\n" "$(basename "$0")" "$1"
	fi
	printf "\e[0m"
	printf "\t\t\tUsage:\n%s COMMAND="read"|"write" zFileName ["TEXT"(ifCOMMAND==write]\n\n\n\n" "$(basename "$0")"
	exit 13
}
#
#
# checks:
if [ $# -lt 1 ]; then
	Usage "Too few arguments."
fi
#
zFile="$2"
aDir=$(dirName.bash "$zFile")
errCode=$?
if [ $errCode -ne 0 ]; then
	zFile="$(dirName.bash "$0")"
	zFile="$zFile""/""$2"
fi
#
aCommand="$1"
case "$aCommand" in
	"read")
	if [ -f "$zFile" ]; then
		cat "$zFile"
	else
		Usage "File '""$zFile""' does not exist."
		exit 13
	fi
	;;
	"write")
	echo "$3" > "$zFile"
	if [ $? -eq 0 ]; then
		echo "$3"
	else
		clear; printf "\n\n\n\t\t\tThe TEXT:\n'%s'\n\thas NOT been written to '%s'\n\n\n\n" "$3" "$zFile"; exit 13
	fi
	;;
	*)
	Usage "Unrecognized COMMAND = '""$aCommand""'."
	;;
esac
#
# eof
