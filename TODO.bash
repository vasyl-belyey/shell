#! /bin/bash
#
# Functions:
. "$(vbShellDir.bash)""/exists.fun"
#
eSpeak() {
	local phrase="$1"
	local nRepeat="$2"
	if ! isInteger.bash "$nRepeat"; then nRepeat=1; fi
	# printColored.bash yellow "\n\n\n\t\t\tDEBUG: phrase: '""$phrase""', nRepeat: '""$nRepeat""'.\n"
	for((iRepeat = 0; iRepeat < nRepeat; iRepeat++)); do
		espeak -a 999 -p 0 -s 60 "$phrase" 2>/dev/null
	done
}
#
showTODO() {
	clear
	printf "\n\n\n"
	#
	if ! isInteger.bash "$iCall"; then
		iCall=0
	fi
	iCall=$((iCall + 1))
	#
	local nCalls=13
	if ! isInteger.bash "$nCalls"; then
		nCalls=13
	fi
	#
	local fRepeat
	if ! isInteger.bash "$fRepeat"; then
		fRepeat=3
	fi
	#
	if [ $((iCall % nCalls)) -eq 0 ]; then
		fRepeat=1
	else
		fRepeat=0
	fi
	local nRepeats=3
	if [ $fRepeat -eq 0 ]; then
		nRepeats=1
	fi
	#
	if ! isInteger.bash "$timeOut"; then
		timeOut=$((13*60))
	fi
	local aLine
	local zLine=""
	local iItem=1
	local exitCode
	while read aLine
#	for aLine in "$(cat "$todoFile")"
	do
		if [ "$zLine" = "" ]; then zLine="$aLine"; fi
		printColored.bash $iItem "\t""$iItem"") \t""$aLine""\n"
		if [ $wholeFile -ne 0 ]; then
			eSpeak "$aLine"
		fi
		iItem=$((iItem+1))
#	done
	done < "$todoFile"
	printf "\n\n\n"
	#
	local cTime
	local aKey=""
	while [ "$aKey" = "" ]; do
		#
		cTime="$(date +%H)"
		if [ $cTime -ge $sluttTime ]; then
			if ! isInteger.bash "$aCount"; then
				aCount=1
			else
				printColored.bash red "\n\n\n\n\n\t\t\tStopping at ""$(date)""\n\n\n"
				eSpeakVB.bash "$(basename "$0")"" stopped."
				exit 0
			fi
		fi
		#
		if [ $wholeFile -eq 0 ]; then
			# espeak -a 999 -p 0 -s 60 "Remember about your to do list!" 2>/dev/null
			if [ $fRepeat -ne 0 ]; then
				eSpeak "Remember about your to do list!" 1
			fi
			exitCode=$?
			for((i = 0; i < nRepeats; i++)); do
				# sleep 1
				aLine=""
				read -t 1 -s -n 1 aLine
				if [ "$aLine" != "" ]; then break; fi
				#
				if [ $exitCode -eq 0 ]; then
					# espeak -a 999 -p 0 -s 60 "$zLine" 2>/dev/null
					eSpeak "$zLine"
				else
					Beep.sh 1
				fi
			done
		fi
		#
		aLine=""
		read -t $timeOut -p "       ""$(date +%H:%M:%S)   ""Next timeout, minutes: [""$((timeOut/60))""] " aLine
		if isInteger.bash "$aLine"; then
			if [ $aLine -lt 1 ]; then aLine=3; fi
			timeOut=$((aLine * 60))
			#
			aLine=""
			read -p "       Enter slutt time: [""$sluttTime""] " aLine
			if isInteger.bash "$aLine"; then
				sluttTime=$aLine
			fi
			#
			printColored.bash green "\n       Okay, waiting for ""$((timeOut/60))"" mins.  Hit a key to continue...   "
			read -n 1 -t $timeOut -s aKey
			printf "\n"
			if ! CMD="$(zFile.bash write "$zFileT" "$timeOut"" ""$sluttTime")"; then
				printColored.bash red "\tERROR writing '""$zFileT""'.\n"
				exit 13
			fi
		else
			aCount=""
			# printf "\n"
			printf "\r"
			aKey="$aLine"
		fi
	done
}
#
# Init:
clear
usageLine="$(basename "$0")"" [TODO filePath]"
if ! isInteger.bash "$sluttTime"; then
	sluttTime=19
fi
if [ $sluttTime -ge $(date +%H) ]; then
	sluttTime=24;
fi
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
sluttTime="19"
zFileT="$(dirName.bash "$0")""/""$(basename "$0")"".times.txt"
if exists -f "$zFileT"; then
	if ! timeOut="$(zFile.bash read "$zFileT")"; then
		timeOut=$((13 * 60))
		printColored.bash red "\tERROR reading '""$zFileT""'.  Default timeOut = ""$timeOut"" sec  (""$((timeOut / 60))"" min).\n"
	else
		timeOut=(${timeOut[*]})
	fi
	# echo "timeOut[${#timeOut[*]}] = '${timeOut[*]}'"
	if [ ${#timeOut[*]} -ne 2 ]; then
		printColored.bash red "\tERROR reading '""$zFileT""'.  timeOut's length != 2\n"
		exit 13
	fi
	sluttTime="${timeOut[0]}"
	sluttTime="${timeOut[1]}"
else
	timeOut=$((13 * 60))
	printColored.bash red "\t\tDefault timeOut = ""$timeOut"" sec  (""$((timeOut / 60))"" min).\n"
fi
if ! CMD="$(zFile.bash write "$zFileT" "$timeOut"" ""$sluttTime")"; then
	printColored.bash red "\tERROR writing '""$zFileT""'.\n"
	exit 13
fi
printColored.bash yellow "\t\ttimeOut = '""$((timeOut / 60))""' [min] = ""$(printSeconds.bash "$timeOut")"";  sluttTime = '""$sluttTime""':00:00 \n"
#
#
# Main:
todoFile="$1"
wholeFile=1
if [ "$todoFile" = "" ]; then
	todoFile="$0"".txt"
	wholeFile=0
fi
#
if [ ! -f "$todoFile" ]; then
	printUsage.bash "$usageLine" "TODO file '""$todoFile""' does not exist."
	if askYN.bash "Create '""$todoFile""' ?"; then
		read -p "       Enter a TODO item: " aLine
		printf "%s" "$aLine" > "$todoFile"
	fi
fi
#
printColored.bash green "\n\t\t\tUsing TODO file '""$todoFile""'"
for((i = 0; i < 3; i++)) do
	printColored.bash green "."
	Beep.sh 1
	sleep 1
done
printf "\n\n\n"
#
exitCode=1
while [ $exitCode -ne 2 ]; do
	showTODO
	selectItem.bash "   Select action:" "Edit" "Exit" "Continue..."
	exitCode=$?
	case $exitCode in
		1)
			vi "$todoFile"
		;;
		2)
			exit 13
		;;
		3)
		;;
		*)
			printUsage.bash "$usageLine" "Invalid exitCode = '""$exitCode""'."
			exit 13
		;;
	esac
done
#
# END
# eof
