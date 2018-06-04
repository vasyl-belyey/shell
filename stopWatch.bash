#! /bin/bash
#
# Functions:
#
. "$(vbShellDir.bash)""/doCMD.fun"
. "$(vbShellDir.bash)""/exists.fun"
. "$(vbShellDir.bash)""/askYN.fun"
. "$(vbShellDir.bash)""/askYNsilent.fun"
. "$(vbShellDir.bash)""/askProceed.fun"
. "$(vbShellDir.bash)""/printFile.fun"
. "$(vbShellDir.bash)""/isMac.fun"
. "$(vbShellDir.bash)""/isInteger.fun"
. "$(vbShellDir.bash)""/stringContains.fun"
. "$(vbShellDir.bash)""/indexOf.fun"
. "$(vbShellDir.bash)""/parseOption.fun"
. "$(vbShellDir.bash)""/printSeconds.fun"
. "$(vbShellDir.bash)""/printColored.fun"
. "$(vbShellDir.bash)""/printColoredOpt.fun"
. "$(vbShellDir.bash)""/isSudoer.fun"
. "$(vbShellDir.bash)""/lsofVB.fun"
. "$(vbShellDir.bash)""/cursorGoTo.fun"
. "$(vbShellDir.bash)""/paPlay.fun"
#
signalSound() {
	local iOpt="$1"
	if ! isInteger "$iOpt"; then iOpt=0; fi
	case $iOpt in
		1)
		;;
		2)
		;;
		*)
			# paplay /usr/share/sounds/ubuntu/stereo/desktop-login.ogg &
			paPlay $signalSound &
			sayPhrase
		;;
	esac
}
#
sayPhrase() {
	local aPhrase="$1"
	if [ -z "$aPhrase" ]; then
		aPhrase="$phrase"
	fi
	if [ ! -z "$aPhrase" ]; then (eSpeakVB.bash "$aPhrase" & 2>/dev/null); fi
}
#
printInfo() {
	# printf "\nprinting sInfo = '%s'...\n" "$sInfo"
	if [ ! -z "$sInfo" ]; then
		printColored.bash green "$sInfo"
		sInfo=""
	fi
}
#
adjustOptions() {
	if [ $verbose -eq 0 ]; then (sayPhrase "adjust options"); fi
	printf "\n"
	# printUsage.bash "$usageLine"
	read -p "   Enter options: [-h$dtSignalH -m$dtSignalM -s$dtSignalS]  " answer
	local dt
	#
	if dt="$(parseOption -s $answer)"; then
		if ! isInteger "$dt"; then
			printUsage.bash "$usageLine" "signalIntervalSEC must be integer (not '""$dt""')."
			return 13
		fi
		dtSignalS=$dt
	fi
	#
	if dt="$(parseOption -m $answer)"; then
		if ! isInteger "$dt"; then
			printUsage.bash "$usageLine" "signalIntervalMIN must be integer (not '""$dt""')."
			return 13
		fi
		dtSignalM=$dt
	fi
	#
	if dt="$(parseOption -h $answer)"; then
		if ! isInteger "$dt"; then
			printUsage.bash "$usageLine" "signalIntervalH must be integer (not '""$dt""')."
			return 13
		fi
		dtSignalH=$dt
	fi
	#
	dtSignal=$((dtSignalS + dtSignalM*60 + dtSignalH*3600))
	#
	if dt="$(parseOption -c $answer)"; then
		if ! isInteger "$dt"; then
			printUsage.bash "$usageLine" "cCount must be integer (not '""$dt""')."
			return 13
		fi
		cCount=$dt
	fi
	#
	return 0
}
#
writeCount() {
	echo "cCount=$cCount; tSignal=$tSignal; phrase=\"$phrase\"" > "$cCountFile"
}
#
writeMarker() {
	echo "tMarker=(${tMarker[*]})" > "$cMarkerFile"
}
showMarker() {
	if [ -z "${tMarker[0]}" ]; then return 0; fi
	printf "\n\t\t\t"
	if pc=$(isMac); then
		local s=$(date +%s); printColored red "tMarker=($(date -v -"$s"S -v +"${tMarker[0]}"S))"
	else
		printColored red "tMarker=($(date --date=@${tMarker[0]})"
	fi
	printColored green " (+$(printSeconds $(($(date +%s) - tMarker[0])) ))"
	printColored red ", counted ${tMarker[1]}"
	local iDiv=${tMarker[1]}
	if [ $iDiv -lt 1 ]; then iDiv=1; fi
	# if [ ${tMarker[1]} -gt 0 ]; then
	# 	printColored green " ($(printSeconds $(( ($(date +%s) - tMarker[0]) / tMarker[1] )) ) per Signal)"
	# else
	# 	printColored green " ($(printf "%+d" ${tMarker[1]} ))"
	# fi
	printColored green " ($(printSeconds $(( ($(date +%s) - tMarker[0]) / iDiv )) ) per Signal)"
	printColored red ")"
	local sss=$((tMarker[2] / 2))
	if [ $((tMarker[2] % 2)) -ne 0 ]; then sss="$sss""$(printf '\u00BD\n')"; fi
	printColored magenta ";  Confirmed ${tMarker[2]} (" green "$sss" magenta ") times."
	# printColored green "$sss"
	# printColored magenta ") times."
	printf "\t\t\t\t\t\t\t\t"
	printf "\033[1A" # cursor up 1 line
}
#
# Init:
clear
printf "\n\n\n"
# printColored green "\t\t\tStart at ""$(date +%Y%m%dT%H:%M:%S)"" ...\n\n\n"
usageLine="$(basename "$0")""\n\n\tShow stopwatch.\noptions:\n\t-s signalIntervalSEC\n\t-m signalIntervalMIN\n\t-h signalIntervalHOUR\n\t-o offsetSEC\n\t-S 'signalSound(s)'"
usageLine="$usageLine""\n\t-v -> verbose\n\t-V 'voice phrase'\n\t-T timeOutSEC\n\t-c cCount"
usageLine="$usageLine""\n\n\t\t$(printColoredOpt -Abold -Cyellow "Control keys:")"
usageLine="$usageLine""\n\t($(printColoredOpt -Abold -Cred "q"))uit;"
# usageLine="$usageLine""\n\t($(printColoredOpt -Abold -Cgreen "r"))uit;"
usageLine="$usageLine""\n\t($(printColoredOpt -Abold -Cgreen "r"))estart;"
usageLine="$usageLine""\n\tad($(printColoredOpt -Abold -Cgreen "j"))ust;"
usageLine="$usageLine""\n\t($(printColoredOpt -Abold -Cgreen "c"))onfirm;"
usageLine="$usageLine""\n\t($(printColoredOpt -Abold -Cgreen "C"))ommand;"
usageLine="$usageLine""\n\t($(printColoredOpt -Abold -Cgreen "-")) show usage."
usageLine="$usageLine""\n\t($(printColoredOpt -Abold -Cgreen "H")) show HEADER (command line)."
hintLine="q(uit) / r(estart) / p(ause)/un(p)ause / ad(j)ust options / (c)onfirm / (-)usage; "
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if ! dtSignalS="$(parseOption -s $*)"; then dtSignalS=0; fi
if ! isInteger "$dtSignalS"; then
	printUsage.bash "$usageLine" "signalIntervalSEC must be integer (not '""$dtSignalS""')."
	exit 13
fi
if ! dtSignalM="$(parseOption -m $*)"; then dtSignalM=0; fi
if ! isInteger "$dtSignalM"; then
	printUsage.bash "$usageLine" "signalIntervalMIN must be integer (not '""$dtSignalM""')."
	exit 13
fi
if ! dtSignalH="$(parseOption -h $*)"; then dtSignalH=0; fi
if ! isInteger "$dtSignalH"; then
	printUsage.bash "$usageLine" "signalIntervalH must be integer (not '""$dtSignalH""')."
	exit 13
fi
dtSignal=$((dtSignalS + dtSignalM*60 + dtSignalH*3600))
#
if ! offsetSEC="$(parseOption -o $*)"; then offsetSEC=0; fi
if ! isInteger "$offsetSEC"; then
	printUsage.bash "$usageLine" "offsetSEC must be integer (not '""$offsetSEC""')."
	exit 13
fi
#
if verbose="$(parseOption -v $*)"; then verbose=0; else verbose=1; fi
#
cCountFile="$0".$dtSignal.txt
if ! phrase="$(parseOption -V $*)"; then
	if [ -f "$cCountFile" ]; then
		read phrase < "$cCountFile"
		eval "$phrase"
	else
		phrase=""
	fi
fi
#
if ! signalSound="$(parseOption -S $*)"; then signalSound="desktop login"; fi
#
if ! timeOutSEC="$(parseOption -T $*)"; then timeOutSEC=1; fi
if ! isInteger "$timeOutSEC"; then
	printUsage.bash "$usageLine" "timeOutSEC must be integer (not '""$timeOutSEC""')."
	exit 13
fi
#
if ! cCount=$(parseOption -c $*); then
	if [ -f "$cCountFile" ]; then
		read cCount < "$cCountFile"
		eval "$cCount"
	else
		cCount=0
	fi
fi
if ! isInteger "$cCount"; then
	printUsage.bash "$usageLine" "cCount must be integer (not '""$cCount""')."
	exit 13
fi
#
cMarkerFile="$0".$dtSignal.Marker.txt
if [ -f "$cMarkerFile" ]; then
	read tMarker < "$cMarkerFile"
	eval "$tMarker"
else
	tMarker=()
fi
#
cCMDFile="$0".$dtSignal.CMD.txt
if [ -f "$cCMDFile" ]; then
	read aCMD < "$cCMDFile"
else
	aCMD=""
fi
#
#
#
t00=$(date +"%s")
sInfo=""
if [ $dtSignal -gt 0 ]; then
	# printColored green "\t\t\tStart at ""$(date)""; signal every ""$(printSeconds $dtSignal)"" ...\n\n\n"
	sInfo="\t\t\tStart at ""$(date)""; signal every ""$(printSeconds $dtSignal)"" ...\n\n\n"
else
	# printColored green "\t\t\tStart at ""$(date)"" ...\n\n\n"
	sInfo="\t\t\tStart at ""$(date)"" ...\n\n\n"
fi
# printInfo
# Main:
signalSound
if [ $verbose -eq 0 ]; then sayPhrase "start"; fi
t0=$(( $(date +"%s") - offsetSEC )); dt=$(($(date +"%s") - t0))
aPause=0
if ! isInteger $tSignal; then tSignal=$(( t0 + dtSignal )); fi
writeCount
tLastCycle=$(date +"%s")
for((;;)); do
	#
	if [ $(($(date +"%s") - tLastCycle)) -ge $((5 * timeOutSEC)) ]; then
		printf "\n\n\n"
		askYNsilent "       Too long cycle ($(printSeconds $(($(date +"%s") - tLastCycle)))).  Proceed?"
	fi
	tLastCycle=$(date +"%s")
	#
	printInfo
	if [ $aPause -eq 0 ]; then
		dt=$(($(date +"%s") - t0))
		aColor="green"
	else
		aColor="red"
	fi
	printColored "$aColor" "\r$(printSeconds $dt)\t"
	printf "<"
	if [ $cCount -le 0 ]; then
		printColored red " $cCount "
	else
		printColored green " $cCount "
	fi
	printf ">\t"
	# printColored yellow "q(uit) / r(estart) / p(ause)/un(p)ause / ad(j)ust options / (c)onfirm / (-)usage; "
	printColored yellow "$hintLine"
	printColored cyan "total ""$(printSeconds $(($(date +"%s") - t00)) )""   "
	if [ $dtSignal -gt 0 ]; then
		ttleft=$(( tSignal - $(date +"%s") ))
		if [ $ttleft -lt $((2 * dtSignal / 3)) ]; then
			if [ $ttleft -lt $((dtSignal / 3)) ]; then
				aColor="green"
			else
				aColor="yellow"
			fi
		else
			aColor="red"
		fi
		#
		if [ $cCount -ge 1 ]; then tSignalNext=$tSignal; else tSignalNext=$((tSignal - cCount*dtSignal)); fi
		# printColored "$aColor" "(signal at $(date --date=@$tSignal) in ""$(printSeconds $ttleft )"")  "
		if pc=$(isMac); then
			s=$(date +%s); printColored "$aColor" "(signal at $(date -v -"$s"S -v +"$tSignalNext"S) in ""$(printSeconds $ttleft )"")  "
		else
			printColored "$aColor" "(signal at $(date --date=@$tSignalNext) in ""$(printSeconds $ttleft )"")  "
		fi
	fi
	#
	showMarker
	#
	# if [ $dtSignal -gt 0 ] && [ $(( ( $(date +"%s") - t0 ) % dtSignal )) -eq 0 ]; then
	if [ $dtSignal -gt 0 ] && [ $(date +"%s") -ge $tSignal ]; then
		t0=$(date +"%s")
		tSignal=$(( tSignal + dtSignal ))
		# paplay /usr/share/sounds/ubuntu/stereo/desktop-login.ogg &
		signalSound
		((cCount++)); writeCount
		if ! [ -z "${tMarker[0]}" ]; then ((tMarker[1]++)); writeMarker; fi
		sInfo="\n\tsignalled $cCount ""$(date)""\n"
	fi
	read -s -n1 -t $timeOutSEC answer
# printf "'%s'\n" "$answer"
	if [ "$answer" = "j" ] && adjustOptions; then answer="r"; fi
	# sleep $timeOutSEC
	case "$answer" in
		"p") # " ")
			# pause / unpause
			if [ $aPause -eq 0 ]; then
				aPause=1
				# paplay /usr/share/sounds/ubuntu/stereo/phone-outgoing-busy.ogg &
				paPlay phone-outgoing-busy &
				if [ $verbose -eq 0 ]; then sayPhrase "paused"; fi
				sInfo="\n\tpaused ""$(date)""\n"
			else
				aPause=0
				# paplay /usr/share/sounds/ubuntu/stereo/phone-outgoing-calling.ogg &
				paPlay phone outgoing calling &
				if [ $verbose -eq 0 ]; then sayPhrase "unpaused"; fi
				sInfo="\n\tun-paused ""$(date)""\n"
			fi
# printf "%d\n" $aPause
		;;
		"M")
			# Marker
			tM=$(date +"%s")
			if [ $verbose -eq 0 ]; then sayPhrase Marker; fi
			if [ -z "${tMarker[0]}" ]; then
				sInfo="\n\tMarker ""$(date)"" with cCount $cCount\n"
			else
				sInfo="\n\tMarker ""$(date)"" (+$(printSeconds $((tM-tMarker[0])) )) with cCount $cCount ($(printf "%+d" ${tMarker[1]} ))\n"
			fi
			# tMarker=($tM $cCount 0)
			tMarker=($tM 0 0)
			writeMarker
		;;
		"r")
			# restart
			t0=$(date +"%s")
			tSignal=$(( t0 + dtSignal ))
			signalSound
			cCount=0; writeCount
			if [ $verbose -eq 0 ]; then sayPhrase reset; fi
			sInfo="\n\treset ""$(date)""\n"
		;;
		"c")
			# confirm
			# signalSound
			if [ $verbose -eq 0 ]; then sayPhrase confirmed; fi
			((cCount--)); writeCount
			if ! [ -z "${tMarker[0]}" ]; then ((tMarker[2]++)); writeMarker; fi
			if [ $cCount -lt 0 ]; then
				sInfo="\n\tconfirmed WRONG DECISION $cCount.  ""$(date)""\n\n"
			else
				sInfo="\n\tconfirmed $cCount.  ""$(date)""\n\n"
			fi
			printf "\n\n\n\n\n\n\n"
		;;
		"C")
			# command
			if [ $verbose -eq 0 ]; then sayPhrase "Enter a command"; fi
			printf "\n\n\n"
			read -p "       Enter a command: [$aCMD] " answer
			if [ ! -z "$answer" ]; then
				if [ -z "$aCMD" ] || [ ${#answer} -gt 3 ]; then
					aCMD="$answer"
					printf "%s\n" "$aCMD" > "$cCMDFile"
				else
					vi "$cCMDFile"
					read aCMD < "$cCMDFile"
				fi
			fi
			sInfo="\n\tcommand '$aCMD' ""$(date)""\n"
			if [ ! -z "$aCMD" ]; then
				printf "\n\n\n\t\t\t doing eval '$aCMD' ...\n\n\n"
				eval "$aCMD"
				printf "\n\n\n"
			fi
		;;
		"H")
			# show HEADER (command line)
			printColored green "\n\n\n\n\t$0 $* -V\"$phrase\"  \n\n"; sleep 3; echo
			# sInfo="\n\tconfirmed ""$(date)""\n"
		;;
		"-")
			# print_usage
			# signalSound
			printf "\n$usageLine\n"
			if [ $verbose -eq 0 ]; then sayPhrase usage; fi
			# sInfo="\n\tconfirmed ""$(date)""\n"
		;;
		"q")
			# quit
			break
		;;
		*)
			# continue
		;;
	esac
done
#
# END
printf "\n\n\n"
signalSound
if [ $verbose -eq 0 ]; then sayPhrase "exit"; fi
# eof
