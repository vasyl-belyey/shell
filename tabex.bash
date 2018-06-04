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
. "$(vbShellDir.bash)""/maxOf.fun"
. "$(vbShellDir.bash)""/minOf.fun"
. "$(vbShellDir.bash)""/dirName.fun"
# . "$(vbShellDir.bash)""/includeAll.fun"; (includeAll 2>/dev/null)
#
# Init:
printf "\n\n\n"
usageLine="$(basename "$0")"
nsd=$((3600*24))
timeout=1
aDate=(2018 2 16 9 0 3)
t0=$(printf "%04d-%02d-%02d %02d:%02d:%02d" ${aDate[0]} ${aDate[1]} ${aDate[2]} ${aDate[3]} ${aDate[4]} ${aDate[5]})
t0=$(date --date="$t0" +%s)
printColored magenta "\n\n\n\t\t\t The 1-st day start = $(date --date=@$t0) \n\n\n"
t00=$(( t0 - (t0 % nsd) ))
#
filLast=$(dirName "$0")/$(basename "$0").lastDay.txt
if ! exists -f "$filLast"; then
	echo "0" > "$filLast"
fi
lastDay=$(cat "$filLast")
printColored yellow "lastDay = $lastDay \n"
echo
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
#
# Main:
for((;;)) do
	iDay=$(( ($(date +%s) - t00) / nsd + 1))
# echo "'$iDay'"; exit 13
	# if [ $iDay -lt 1 ]; then nDay=0; else nDay=$((iDay - 0)); fi
	nDay=$iDay
	#
	if [ $nDay -gt 25 ]; then
		printColored green "\n\n\n\t\t\t Course is over.  Congrats!!! \n\n\n"
		break
	fi
	#
	t1=$(( t0 + (nDay-1)*nsd ))
	dt=$(( t1 - $(date +%s) ))
	printColored white "\r\t day $iDay, $(date)" green "\t start in $(printSeconds $dt)" yellow " ($(date --date="@$t1"))" red "\t (q to quit)""\t\t\t"
	#
# nDay=20; lastDay=0; dt=$(( dt - nsd - 20*60 ))
	if [ $nDay -gt 0 ] && [ $lastDay -lt $nDay ] && [ $dt -le 0 ]; then
# rm -v "$filLast"
		case "$nDay" in
			[1-3])
				nTabs=6
				dtTabs=$((2*3600))
			;;
			[4-9])
				nTabs=5
				dtTabs=$((2*3600 + 30*60))
			;;
				1[0-2])
					nTabs=5
					dtTabs=$((2*3600 + 30*60))
				;;
			1[3-6])
				nTabs=4
				dtTabs=$((3*3600 + 0*60))
			;;
			1[7-9])
				nTabs=3
				dtTabs=$((5*3600 + 0*60))
			;;
				20)
					nTabs=3
					dtTabs=$((5*3600 + 0*60))
				;;
			2[1-5])
				nTabs=1
				dtTabs=$((24*3600 + 0*60))
			;;
		esac
		phrase=$(printf "day_%d_svallow_%d_tablets_every_%d_hours" $nDay $nTabs $((dtTabs / 3600)) )
		if [ $((dtTabs % 3600)) -ne 0 ]; then
			phrase="$phrase""$(printf "_%d_minutes" $(( (dtTabs % 3600)/60 )) )"
		fi
		CMD="stopWatch.bash -s $dtTabs -V $phrase -c1"
		doCMD "$CMD" 1 1
		lastDay=$nDay; echo "$lastDay" > "$filLast"
# exit 13
	else
		read -s -n1 -t$timeout answer
		if [ "$answer" = "q" ]; then break; fi
	fi
#	lastDay=$nDay
	#
done
#
# END
printf "\n\n\n"
# eof
