#! /bin/bash
#
# Functions
myBeep() {
	if isInteger.bash $1; then
		Beep.sh $1
	fi
}
#
Usage() {
	#
	printUsage.bash "$usageLine" "$1"
	exit 13
	#
	clear
	printf "\n\n\n"
	if [ "$1" != "" ]; then
		printf "\t%s\n" "$1"
	fi
	printf "\t\t\tUsage:\n%s errCode|"CMD" [NbeepsAfterReport]\n\n\n" "$(basename $0)"
	exit 13
}
#
#
usageLine="$(basename "$0")"" errCode|Command [nBeeps]"
#
if [ $# -lt 1 ]; then
	# 1="$?"; 2="1"
	Usage "No arguments given."
fi
#
if isInteger.bash $1; then
	if [ $1 -eq 0 ]; then
		# setTextAttributes.bash bold green
		# printf "\n\n\n\t\t\tSUCCESS\n\n\n"
		# setTextAttributes.bash
		printColored.bash green "\n\n\n\t\t\tSUCCESS\n\n\n"
		if [ $# -gt 1 ]; then
			eSpeakVB.bash "Success"
		fi
		myBeep $2
	else
		# setTextAttributes.bash bold red yellow
		# printf "\n\n\n\t\t\tERROR %d\n\n\n" $1
		# setTextAttributes.bash
		printColored.bash red "\n\n\n\t\t\tERROR ""$1""\n\n\n"
		if [ $# -gt 1 ]; then
			eSpeakVB.bash "Error ""$1"
			myBeep $((2*$2))
		fi
	fi
	errCode=$1
else
	if [ $# -gt 1 ]; then
		if isInteger.bash $2; then
			CMD="$1"
			printf "\n\n\n\t\t\t>>>>>>> Doing '%s'... <<<<<<<\n\n\n" "$CMD"
			$CMD
			errCode=$?
			checkErrorCode.sh $errCode $2
			printf "\n\n\n\t\t\t<<<<<<< Done '%s'. >>>>>>>\n\n\n" "$CMD"
		else
			Usage "Second argument not numeric."
		fi
	else
		CMD="$1"
		printf "\n\n\n\t\t\t>>>>>>> Doing '%s'... <<<<<<<\n\n\n" "$CMD"
		$CMD
		errCode=$?
		checkErrorCode.sh $errCode
		printf "\n\n\n\t\t\t<<<<<<< Done '%s'. >>>>>>>\n\n\n" "$CMD"
	fi
fi
#
exit $errCode
#
# eof
