askYNsilent() {
#
# Init
	local usageLine="$(basename "$0")"" promptText [answerSymbols(yn) [defaultAnswerIndex(0) [immediateReaction(no 'ENTER')]]]"
immediateReaction=0; if [ $# -ge 4 ]; then immediateReaction=1; fi
# checks
arg1="$1"
if [ $# -lt 1 ]; then
	printUsage.bash "$usageLine" "promptText must be given (use \"\" if none)."
	exit -1
fi
if [ $# -eq 1 ] && [ "${arg1:0:1}" = "-" ]; then
	printUsage.bash "$usageLine"
	exit -1
fi
#
defYN="$2"
if [ "$defYN" = "" ]; then
	defYN="yn"
fi
# symbol list:
sList=""; nSymbols=0; sVals=" ("
if [ $immediateReaction -eq 0 ]; then
	colorON="$(setTextAttributes.bash bold green)"
else
	colorON="$(setTextAttributes.bash bold red)"
fi
colorOFF="$(setTextAttributes.bash)"
#
for ((iS=0; iS<${#defYN}; iS++))
do
	if [ "${defYN:$iS:1}" != " " ]; then
		sVals="$sVals""${defYN:$iS:1}"
		if [ $((iS+1)) -lt ${#defYN} ]; then sVals="$sVals""/"; fi
		sList[$nSymbols]="${defYN:$iS:1}"
		nSymbols=$((nSymbols+1))
	fi
done
sVals="$sVals"") "
#
if [ $nSymbols -lt 1 ]; then
	printUsage.bash "$usageLine" "Bad (empty) answerSymbols '""$defYN""'."
	exit -1
fi
#
retVal=0
defYN=${sList[0]}
#
if [ $nSymbols -gt 1 ]; then
	if [ $# -ge 3 ]; then
		if ! isInteger.bash $3; then
			printUsage.bash "$usageLine" "DefaultAnswerIndex must be integer between 0 and $((nSymbols-1)) ('""$3""' given)."
			exit -1
		fi
		if [ $3 -lt 0 ] || [ $3 -ge $nSymbols ]; then
			printUsage.bash "$usageLine" "DefaultAnswerIndex must be integer between 0 and $((nSymbols-1)) ('""$3""' given)."
			exit -1
		fi
		defYN="${sList[$3]}"
	fi
#
	sPrompt="$1""$colorON""$sVals""$colorOFF"" [""$defYN""]: "
	retVal=-1
	while [ $retVal -lt 0 ];
	do
		printf "\r"
		printColored.bash yellow "$sPrompt"
		sS="$1"
# printf "\nsS0='%s'\n" "$sS"
		sS="${sS/*\\t/}"
		sS="${sS/*\\n/}"
# printf "sS1='%s'\n" "$sS"
# return 13
		# eSpeakVB.bash "$sS"
		if [ $immediateReaction -ne 0 ]; then
			# read -n 1 -p "$sPrompt" answer
			read -n 1 answer
		else
			# read -p "$sPrompt" answer
			read answer
		fi
		if [ "$answer" = "" ]; then
			answer="$defYN"
		fi
#		echo; echo "Entered: '$answer'"
		for ((iS=0; iS<nSymbols; iS++))
		do
			if [ "$answer" = "${sList[$iS]}" ]; then
				retVal=$iS
				break
			fi
		done
		if [ $retVal -lt 0 ]; then
			if [ $immediateReaction -ne 0 ]; then
				printf "\t\t\tBad symbol '%s' :-(, try again" "$answer"
			else
				printf "\e[1A\t\t\tBad symbol '%s' :-(, try again" "$answer"
			fi
		fi
	done
fi
#
if [ $immediateReaction -ne 0 ]; then
	printf "\n"
fi
#
#echo "$retVal"
# exit $retVal
return $retVal
}
#
# eof
