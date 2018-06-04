#! /bin/bash
#
# Functions:
#
# . "$(vbShellDir.bash)""/doCMD.fun"
# . "$(vbShellDir.bash)""/exists.fun"
# . "$(vbShellDir.bash)""/askYN.fun"
. "$(vbShellDir.bash)""/askYNsilent.fun"
. "$(vbShellDir.bash)""/askProceed.fun"
# . "$(vbShellDir.bash)""/printFile.fun"
# . "$(vbShellDir.bash)""/isMac.fun"
. "$(vbShellDir.bash)""/isInteger.fun"
# . "$(vbShellDir.bash)""/stringContains.fun"
# . "$(vbShellDir.bash)""/indexOf.fun"
# . "$(vbShellDir.bash)""/parseOption.fun"
# . "$(vbShellDir.bash)""/printSeconds.fun"
. "$(vbShellDir.bash)""/printColored.fun"
# . "$(vbShellDir.bash)""/printColoredOpt.fun"
# . "$(vbShellDir.bash)""/isSudoer.fun"
# . "$(vbShellDir.bash)""/lsofVB.fun"
# . "$(vbShellDir.bash)""/cursorGoTo.fun"
# . "$(vbShellDir.bash)""/paPlay.fun"
# . "$(vbShellDir.bash)""/maxOf.fun"
# . "$(vbShellDir.bash)""/minOf.fun"
. "$(vbShellDir.bash)""/dirName.fun"
# . "$(vbShellDir.bash)""/includeAll.fun" # ; (includeAll 2>/dev/null)
#
# Init:
usageLine="$(basename "$0")"" secs1 secs2"
myDir=$(dirName "$0")"/"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if [ $# -ne 2 ]; then
	printUsage.bash "$usageLine" "Wrong number of arguments"
	exit 13
fi
#
for((i = 1; i <= 2; i++)); do
	if ! isInteger "$1"; then
		printUsage.bash "$usageLine" "secs$i must be integer (not '$1')"
		exit 13
	fi
	eval "secs$i=$1"
	shift
done
printColored white "\n\n\n\t\t\t Moving " red "$secs1" white " to " green "$secs2\n\n"
#
filesOld=("$myDir"stopWatch.bash.$secs1.txt $(ls "$myDir""stopWatch.bash.$secs1."*.txt 2>/dev/null))
#
if ! [ -f "${filesOld[0]}" ]; then
	printUsage.bash "$usageLine" "Original file '"${filesOld[0]}"' does not exist"
	exit 13
fi
#
for((i = 0; i < ${#filesOld[*]}; i++)); do
	fileOld="${filesOld[$i]}"
	fileNew=${fileOld/$secs1/$secs2}
	printColored white "processing '" yellow "${filesOld[$i]}" white "':  moving to '" green "$fileNew" white "'...\n"
	if [ -f "$fileNew" ] && ! askYNsilent "       Target file '$fileNew' exists.  Overwrite?"; then
		exit 13
	fi
	if ! mv -v "$fileOld" "$fileNew"; then exit 13; fi
	if [[ "$fileNew" == *.CMD.txt ]] && askYNsilent "             Edit command file '$fileNew'?"; then
		vi "$fileNew"
	fi
done
#
#
# Main:
#
# END
printf "\n\n\n"
# eof
