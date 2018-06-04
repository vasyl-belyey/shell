#! /bin/bash
#
# F:
checkBlueToothStatus() {
	local retVal=1
	local sName="bluetooth"
	printf "\n\t\tChecking '%s' status...\n" "$sName"
	service --status-all | grep "$sName"
	###checkErrorCode.sh $?
	retVal=$?
	local rWord="absent"
	if [ $retVal -eq 0 ]; then
		rWord="present"
	fi
	printf "\n\t\tservice '%s' %s.\n" "$sName" "$rWord"
	printf "\n\n"
	return $retVal
}
#
removeManFile() {
	local retVal=0
		if [ -f "$manFile" ]; then
			printf "\n\tDeleting '%s' file...\n" "$manFile"
			CMD="sudo rm -v ""$manFile"
			if ! checkErrorCode.sh "$CMD"; then
				retVal=13
			fi
		else
			printf "\n\tManual '%s' file absent.\n\n\n" "$manFile"
			retVal=13
		fi
	return $retVal
}
#
# Init:
usageLine="$(basename "$0")"" [off]"
# Checks:
arg1="$1"
if [ "$arg1" != "" ] && [ "${arg1:0:1}" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
wDir="/etc/init"
if [ ! -d "$wDir" ]; then
	printUsage.bash "$usageLine" "Seems not a Linux machine: '""$wDir""' directory not found."
	exit 13
fi
#
# Main:
clear; printf "\n\n\n"
#
case "$arg1" in
	"")
		if ! checkBlueToothStatus; then
			exit 13
		fi
		printf "\t\t\tTurning bluetooth service ON...\n\n"
		manFile="$wDir""/bluetooth.override"
		retVal=0
		if ! removeManFile; then
			retVal=13
		fi
		manFile="$wDir""/cups.override"
		if ! removeManFile; then
			retVal=13
		fi
		if [ $retVal -ne 0 ]; then
			printf "\n\n\n\t\t\tSomething went WRONG... :-(\n\n\n"
			exit 13
		fi
	;;
	"off")
		if ! checkBlueToothStatus; then
			exit 13
		fi
		printf "\t\t\tTurning bluetooth service OFF...\n\n"
		retVal=0
		sudo sh -c "echo 'manual' > /etc/init/bluetooth.override"
		if [ $? -ne 0 ]; then
			retVal=13
		fi
		sudo sh -c "echo 'manual' > /etc/init/cups.override"
		if [ $? -ne 0 ]; then
			retVal=13
		fi
		if [ $retVal -ne 0 ]; then
			printf "\n\n\n\t\t\tSomething went WRONG... :-(\n\n\n"
			exit 13
		fi
	;;
	*)
		printUsage.bash "$usageLine" "Unrecognized argument '""$arg1""'."
		exit 13
	;;
esac
#
printf "\n\n\n\t\t\tSUCCESS.  You (probably) need to reboot...\n\n\n"
#
# eof
