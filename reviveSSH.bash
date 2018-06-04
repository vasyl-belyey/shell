#! /bin/bash
#
# Functions
#
#
# Init:
usageLine="$(basename "$0")"
#
# main:
clear
#
# Check for help:
if [ $# -gt 0 ]; then
	arg1="$1"
	if [ "${arg1:0:1}" = "-" ]; then
		printf "" > /dev/null
	fi
	printUsage.bash "$usageLine"
	exit 13
fi
#
aOptions[0]="sudo service ssh restart"
aOptions[1]="sudo /etc/init.d/ssh restart"
aOptions[2]="sudo ufw disable"
#
nOptions=${#aOptions[*]}
###printf "\n\n\n\t\t\t%d\n\n\n" $nOptions
#
# try options:
for ((iO=0; iO<nOptions; iO++))
do
	CMD="${aOptions[$iO]}"
	printf "Trying opton %d: %s...\n" $iO "$CMD"
	checkErrorCode.sh "$CMD"
done
#
# ifconfig
ifconfig
#
# eof
