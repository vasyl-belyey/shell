#! /bin/bash
#
# Functions:
#
#
Usage() {
	clear
	printf "\n\n\n"
	if [ "$1" != "" ]; then
		printf "\tERROR: %s\n" "$1"
	fi
	printf "\t\t\tUsage:\n%s \"COMMAND\" [timeOutSECs [header]]\n\n\n" "$(basename "$0")"
	exit 13
}
#
# Init:
usageLine="$(basename "$0")"" \"COMMAND\" [timeOutSECs [header]]"
#
# Checks:
if [ $# -lt 1 ]; then
	#Usage "Too few arguments."
	printUsage.bash "$usageLine" "Too few arguments."
	exit 13
fi
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
CMD="$1"
#
if [ $# -gt 1 ]; then
	if isInteger.bash $2; then
		$CMD &
		prs=$!
		t0=$(date +%s)
		while ps -p $prs > /dev/null; do
			# sleep 1
			read -n1 -t1 -s answer
			t1=$(date +%s)
			dT=$(( t1 - t0 ))
			dTleft=$(( $2 - dT))
			if [ $dTleft -le 0 ] || [ "$answer" = "q" ]; then
				kill $prs
				#############	printf "\n"
				exit 13
			fi
			if [ "$3" != "" ]; then
				pSECs=$(printSeconds.bash $dTleft)
				printf "\r%s %s" "$3" "$pSECs"
				perCent=$(( dTleft*100/$2 ))
				aColor=green
				if [ $perCent -lt 67 ]; then aColor=yellow; fi
				if [ $perCent -lt 33 ]; then aColor=red; fi
				###perCent="$(printf "%d %%" $perCent)"
				if [ $perCent -ge 10 ]; then
					perCent=" ""$perCent"" %% left.   "
				else
					perCent="  ""$perCent"" %% left.   "
				fi
				printColored.bash "$aColor" "$perCent""   (q)uit       "
			fi
		done
	else
		Usage "Second argument non-integer."
	fi
else
	$CMD
	errCode=$?
	exit $errCode
fi
#
# eof
