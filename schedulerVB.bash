#! /bin/bash
#
. "$(vbShellDir.bash)""/isMac.fun"
. "$(vbShellDir.bash)""/indexOf.fun"
# F:
printColored() {
	local sS="$(checkPGM.sh printColored.bash)"
	if [ $? -eq 0 ]; then
		printColored.bash "$1" "$2" "$3"
	else
		printf "$2" "$3"
	fi
}
#
signalAlarm() {
	# Beep.sh 37
	local answer
	local nRepeats=37
	for((i = 0; i < $nRepeats; i++)); do
		printColored.bash green "\r\tReached '""$waitMessage""'\t\t""$((nRepeats - i))""\t\t"
		if ! eSpeakVB.bash "$waitMessage"; then printf "beeping...\n\n\n"; Beep.sh; fi
		answer=""; read -s -n 1 -t 1 answer
		if [ "$answer" != "" ]; then
			case "$answer" in
				"S")
					answer=30
					read -p "             Sleep for minutes [$sleepFor]: " answer
					if isInteger.bash "$answer"; then
						sleepFor=$answer
					fi
					((waitFor += sleepFor*60))
					break
				;;
				*)
					break
				;;
			esac
		fi
	done
	printColored.bash red "\n"
	#
	read -t $((13*60)) -p "             Press any key to continue...   " -n 1 -s answer
	printf "\r%113s" " "
}
#
showHint() {
	printf "\n\n\n"
	printColored yellow "\t\t\tPress: "
	printColored green "q - quit;  "
	printColored red "s - skip current time;  "
	printColored green "a - add new time.  "
	printf "\n\n\n\n"
}
#
showMessage() {
	#
	# local sMessage
	#
	iNow="$(date +%s)"
	local sNow="$(date "+%d.%m.%Y  %H:%M:%S")"
	if ans="$(isMac)"; then
		sNow="Since ""$(date -j -f "%s" "$iStart" "+%d.%m.%Y @ %H:%M:%S")""       ""$sNow"
	else
		sNow="Since ""$(date -d @$iStart "+%d.%m.%Y @ %H:%M:%S")""       ""$sNow"
	fi
	printf "\033[2A" # Up one line
	#printf "\r\t"
	printf "\r"
	sMessage="$sNow""       "
	#######printColored green "$sMessage"
	setTextAttributes.bash bold green
	printf "%s" "$sMessage"
	###sMessage="waiting for ""$(printSeconds.bash "$((waitFor % (3600*24) ))")""       "
	#
	sMessage="waiting for '"
	setTextAttributes.bash bold yellow
	printf "%s" "$sMessage"
	#
	local aColor="green"
	local iRemain=$((waitFor - iNow ))
	if [ $iRemain -lt $((13*60)) ]; then
		aColor="red"
	else
		if [ $iRemain -lt $((30*60)) ]; then
			aColor="yellow"
		fi
	fi
	#
	sMessage="   ""$waitMessage""   "
	setTextAttributes.bash bold "$aColor" black
	printf "%s" "$sMessage"
	setTextAttributes.bash
	#
	if ans="$(isMac)"; then
		sMessage="' on ""$(date -j -f "%s" "$waitFor" "+%d.%m.%Y @ %H:%M:%S")""       "
	else
		sMessage="' on ""$(date -d @$waitFor "+%d.%m.%Y @ %H:%M:%S")""       "
	fi
	setTextAttributes.bash bold yellow
	printf "%s" "$sMessage"
	#
	sMessage="remaining ""$(printSeconds.bash "$iRemain")""       "
	#######printColored "$aColor" "$sMessage"
	setTextAttributes.bash bold "$aColor"
	printf "%s" "$sMessage"
	setTextAttributes.bash
	#
	# Percent bar:
	printf "\n"
	plotVB1.bash $((iNow - iStart)) $((waitFor - iStart))
}
#
addTime() {
							#date -d 10/08/2014 +%s
	local ans
	local def
	local DSTstr
	local retCode
	if askYN.bash "   Add time?"; then
		printColored.bash yellow "\t\t\tAdding to:\n""$(zFile.bash read "$myFile")""\n\n\n"
		waitFor=0
		#
		local aYear="$(date +%Y)"
		def="$aYear"
		printf "\t\t\t"
		read -p "Year [""$def""] " ans
		if [ "$ans" = "" ]; then ans="$def"; fi
		aYear="$(printf "%04d" $ans)"
		if isMac; then
			waitFor=$(date -u -j -f "%Y%m%dT%T" "$aYear""0101T00:00:00" "+%s")
		else
			waitFor=$(date -d 01/01/"$aYear" +%s)
		fi
# echo waitFor="$waitFor"
		#
		local aMonth="$(date +%m)"
		def="$aMonth"
		printf "\t\t\t"
		read -p "Month [""$def""] " ans
		if [ "$ans" = "" ]; then ans="$def"; fi
		while [ "${ans:0:1}" = "0" ]; do ans="${ans:1}"; done
		aMonth="$(printf "%02d" $((ans*1)) )"
		if isMac; then
			waitFor=$(date -u -j -f "%Y%m%dT%T" "$aYear""$aMonth""01T00:00:00" "+%s")
		else
			waitFor=$(date -d "$aMonth"/01/"$aYear" +%s)
		fi
# echo waitFor="$waitFor"
		#
		local aDay="$(date +%d)"
		def="$aDay"
		printf "\t\t\t"
		read -p "Day [""$def""] " ans
		if [ "$ans" = "" ]; then ans="$def"; fi
		while [ "${ans:0:1}" = "0" ]; do ans="${ans:1}"; done
		aDay="$(printf "%02d" $ans )"
		if isMac; then
			waitFor=$(date -j -f "%Y%m%dT%T" "$aYear""$aMonth""$aDay""T00:00:00" "+%s")
		else
			waitFor=$(date -d "$aMonth"/"$aDay"/"$aYear" +%s)
		fi
# echo waitFor="$waitFor"
		#
		printf "\t\t\t"
		read -p "Hour " ans
		while [ "${ans:0:1}" = "0" ]; do ans="${ans:1}"; done
		waitFor=$((waitFor + ans * 3600))
# echo waitFor="$waitFor"
		#
		printf "\t\t\t"
		read -p "Minute " ans
		while [ "${ans:0:1}" = "0" ]; do ans="${ans:1}"; done
		waitFor=$((waitFor + ans * 60))
# echo waitFor="$waitFor"
		# Check DST (Day Saving Time):
# echo waitFor="$waitFor"
		#
		printf "\t\t\t\t"
		read -p "Message " waitMessage
		eSpeakVB.bash "$waitMessage" 1
		#
	else
		waitFor=0; waitMessage=""
# echo "!!!!!!!!!!waitFor=""$waitFor"
	fi
		###	printf "%s\n\n\n\n\n\n\n" "$waitFor"; exit 13
	#
	local tText=""
	tText="$(zFile.bash read "$myFile")"
	if [ $? -ne 0 ]; then tText=""; fi
	local newWaitFor=$waitFor
	local sW="$newWaitFor"":""$waitMessage"
	if [ "$tText" != "" ]; then
		getWaitTime
		if [ $waitFor -le $newWaitFor ]; then
			sW="$tText"":""$sW"
		else
			sW="$sW"":""$tText"
		fi
	fi
	waitFor="$(zFile.bash write "$myFile" "$sW")"
# echo waitFor="$waitFor"
	getWaitTime
}
#
freeTime() {
	local tText="$(zFile.bash read "$myFile")"
	###printf "Old tText = '%s'\n" "$tText"
	if [ "$tText" != "" ]; then
		local nS=${#tText}
		###printf "nS = %d\n" $nS
		local sSemi=":"
		local s2=-1
		local iFound=0
		local aSymbol
		for((iS=0; iS<nS; iS++)); do
			aSymbol="${tText:$iS:1}"
			###printf "%d) aSymbol = '%s'\n" $iS "$aSymbol"
			if [ "$aSymbol" = "$sSemi" ]; then
				iFound=$((iFound + 1))
				###printf "iFound = %d\n" $iFound
				if [ $iFound -ge 2 ]; then
					s2=$iS
					break
				fi
			fi
		done
		###printf "s2 = %d\n" $s2
		if [ $s2 -ge 0 ]; then
			tText="${tText:$((s2 + 1))}"
		else
			tText=""
		fi
	else
		tText=""
	fi
	###printf "New tText = '%s'\n" "$tText"
	###exit 13
	tText="$(zFile.bash write "$myFile" "$tText")"
	getWaitTime
}
#
getWaitTime() {
	local sTimeLine=""
	sTimeLine="$(zFile.bash read "$myFile")"
	###printf "? = %d\n" $?; exit 13
	if [ $? -ne 0 ] || [ "$sTimeLine" = "" ]; then
		waitFor=0; waitMessage=""
# echo waitFor="$waitFor"
	else
		# iPos="$(indexOfSubstring.sh "$sTimeLine" ":")"
		iPos="$(indexOf "$sTimeLine" ":")"
		if [ $iPos -lt 0 ]; then
			waitFor="$sTimeLine"; waitMessage=""
# echo waitFor="$waitFor"
			sTimeLine=""
		else
			waitFor="${sTimeLine:0:$iPos}"
# echo waitFor="$waitFor"
			sTimeLine="${sTimeLine:$((iPos+1))}"
			iPos="$(indexOfSubstring.sh "$sTimeLine" ":")"
			###printf "sTimeLine = '%s' iPos = %d\n" "$sTimeLine" $iPos
			if [ $iPos -lt 0 ]; then
				waitMessage="$sTimeLine"
				sTimeLine=""
			else
				###waitMessage="${sTimeLine:0:$((iPos-1))}"
				waitMessage="${sTimeLine:0:$iPos}"
				sTimeLine="${sTimeLine:$((iPos+1))}"
			fi
		fi
	fi
	#
	# printf "\n\t\t\tgetWaitTime: waitFor = '%s'; waitMessage = '%s'\n\n\n" "$waitFor" "$waitMessage"
}
#
#
# Init:
sleepFor=30
clear; printf "\n\n\n\n\n\n\n"
usageLine="$(basename "$0")"
myDir="$(dirName.bash "$(dirname "$0")")"
myFile="$myDir""/""$(basename "$0")"".times.txt"
getWaitTime
iStart="$(date +%s)"
#
# Checks:
if ! ans="$(isMac)"; then
	answer=$(ps -C "$(basename "$0")" 1> /dev/null)
	if [ $? -ne 0 ]; then
		printUsage.bash "$usageLine" "Already running."
		###exit 13
	fi
fi
if [ $? -ne 0 ]; then
	waitFor=0
fi
answer="$(isInteger.bash "$waitFor")"
if [ $? -ne 0 ]; then
	printUsage.bash "$usageLine" "Non-integer waitFor value '""$waitFor""'"
	exit 13
fi
#
# Main:
iNow="$(date +%s)"
while [ $waitFor -lt $iNow ] && [ $waitFor -gt 0 ]; do
	freeTime
done
if [ $waitFor -lt $iNow ]; then
	addTime
fi
													# echo "HERE: waitFor='""$waitFor""', iNow='""$iNow""'"
if [ $waitFor -ge $iNow ]; then
	showHint
	while [ $waitFor -ne 0 ]; do
		showMessage
													# echo HERE #; exit 13
		read -s -t 1 -n 1 answer
		case "$answer" in
			"q")
				break
			;;
			"s")
				freeTime
			;;
			"a")
				addTime
				clear
				showHint
			;;
		esac
		if [ $waitFor -lt $iNow ]; then
			signalAlarm
			if [ $waitFor -lt $iNow ]; then
				freeTime
			fi
		fi
	done
	#
fi
echo
#
# END
printf "\n\n\n\n\n\n\n"
#
# eof
