# if (doCMD "ls" 1>/dev/null 2>/dev/null); then return; fi
. "isInteger.fun"
# . sleepVB.fun
# echo "'${0#-}' src '${BASH_SOURCE}'"
doCMD() {
	local usageLine="doCMD cmdLine [noAbort [silent=1(onError)|2(auto-if_longer_3sec)|3(always)]]"
	local CMD="$1"
	local abort=1 nSEC=3
	if isInteger "$3" && [ $3 -ge 0 ]; then nSEC=$3; fi
	# if [ ! -z "$2" ]; then
	if isInteger "$2"; then
		abort=$2
	else
		abort=0
	fi
	local silent=1
	if [ $# -gt 2 ]; then
		if isInteger.bash "$3"; then
			silent=$3
		else
			silent=1
		fi
	fi
	printf "\n\n\n"
	printColored.bash blue "\tpwd = '""$(pwd)""':\n"
	printColored.bash yellow "\t\t\tDoing '""$CMD""'...\n"
	if [ "$CMD" = "" ]; then
		printColored.bash red "\n\n\n\t\t\tNo command to do.\n\n\n\n\n\n\n"
		exit 13
	fi
	# EXE:
	local timing=$(date +%s)
	eval "$CMD"
	retVal=$?
	timing=$(( $(date +%s) - timing))
	printColored.bash blue "\tpwd = '""$(pwd)""':\n"
	# Checks:
	local speakMsg="Done '""${CMD:0:13}""'."
	if [ $retVal -eq 0 ]; then
		printColored.bash green "\t\t\tDone  '""$CMD""' for ""$(printSeconds.bash $timing)"".\n\n\n"
	else
		local aMsg="ERROR ""$retVal"" doing '""$CMD""'."
		speakMsg="ERROR ""$retVal"" doing '""${CMD:0:13}""'."
		printColored.bash red "\t\t\t""$aMsg""\n\n\n\n\n\n\n"
		if [ $silent -eq 0 ]; then
			Beep.sh 1 "$speakMsg"
		fi
		if [ $abort -gt 0 ]; then
			sleepVB --nSEC $nSEC
			exit $retVal
		fi
	fi
	if [ $silent -gt 1 ]; then
		if [ $silent -gt 2 ]; then
			Beep.sh 1 "$speakMsg"
		else
			if [ $timing -ge 3 ]; then
				Beep.sh 1 "$speakMsg"
			fi
		fi
	fi
	return $retVal
}
