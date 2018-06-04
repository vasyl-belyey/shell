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
. "$(vbShellDir.bash)""/isSudoer.fun"
. "$(vbShellDir.bash)""/lsofVB.fun"
. "$(vbShellDir.bash)""/cursorGoTo.fun"
#
# Init:
usageLine="$(basename "$0")"" [-f file]"" [-n nSECperiod]"" [-M fileSizeMAX]"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if ! filePath=$(parseOption -f $*); then filePath="$fileDAEMONDlog"; fi
# if ! filePath=$(parseOption -f $*); then filePath="$(pwd)""/""nohup.out"; fi
if ! nSECperiod=$(parseOption -n $*); then nSECperiod=13; fi
fileName=$(basename "$filePath")
if ! fileSizeMAX=$(parseOption -M $*); then fileSizeMAX=$((1024*1024)); fi
#
# Main:
errorCode=0
clear
# while [ $errorCode -eq 0 ]; do
for((iRun = 0; errorCode == 0; iRun++)); do
	printf "%s every %d sec\n" "$(basename "$0")" $nSECperiod
	if ! sSize=$(stat --printf="%s" "$filePath" 2>/dev/null); then sSize=0; fi
	aColor=green
	sOUT=""
	sOUT="$sOUT""$(printColored white "$(date -u +"%Y-%m-%dT%T UT")")""  "
	# sOUT="$sOUT""$(printColored yellow "$fileName")""  "
	sOUT="$sOUT""$(printColored yellow "$filePath")""  "
	nPerCent=$((100 * sSize / fileSizeMAX))
	aColor=green
	if [ $nPerCent -ge 33 ]; then
		aColor=yellow
		if [ $nPerCent -ge 67 ]; then aColor=red; fi
	fi
	sOUT="$sOUT""$(printColored $aColor "$sSize""/""$fileSizeMAX""=""$nPerCent""%%")""  "
	printf "%s\n" "$sOUT"
	#
	# printFile "$filePath" # | tail -13
	cat "$filePath" | head -23
	printf "\t\t\t.............\n"
	cat "$filePath" | tail -23
	# cat "$filePath"
	#
	sOUT=""
	aColor=green
	phdFile="phDaemond.bash"
	if ! sOUT="$(ps -C "$phdFile")"; then sOUT="$phdFile"" is dead"; aColor=red; fi
	printColored $aColor "\n""$sOUT""\n"
	#
	answer=""
	if [ $nPerCent -ge 100 ]; then
		# if askYNsilent "Remove '""$filePath""'"; then
			echo "Removed" > "$filePath"
		# fi
		# clear
	else
		#
		for((iSec = 0; iSec < nSECperiod; iSec++)); do
			printColored blue "\r""$(printSeconds $((nSECperiod - iSec)) )""   ('q' to quit)  "
			answer=""; if ! read -n1 -s -t1 answer 2>/dev/null; then sleep 1; ((iSec++)); fi
			if [ "$answer" = "q" ]; then break; fi
			# if [ "$answer" = "q" ]; then exit; fi
		done
		#
	fi
	if [ "$answer" = "q" ]; then
		break
		# exit
	else
	# 	if [ $((iRun % 2 )) -eq 0 ]; then
	# 		printf "\n\n"
	# 	else
			cursorGoTo 0 0
	# 	fi
	fi
done
#
# END
printf "\n\n\n"
exit 0
# eof
