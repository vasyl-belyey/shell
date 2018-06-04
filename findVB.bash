#! /bin/bash
#
# Functions:
. "$(vbShellDir.bash)""/doCMD.fun"
#
# Init:
clear
usageLine="$(basename "$0")"" what [where=.]"
what="$1"
where="$2"
sFile="soek.txt"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if [ "$what" = "" ]; then
	printUsage.bash "$usageLine" "Nothing to look for: argument 'what' = '""$what""'."
	exit 13
fi
#
if [ "$where" = "" ]; then
	where="."
fi
#
# Main:
t0="$(date +%s)"
CMD="find ""$where"" -iname \"""$what""\" 2>/dev/null 1>""$sFile"
# doCMD "$CMD"
sudo find "$where" -iname "$what" 2>/dev/null 1>"$sFile"
#
t1="$(date +%s)"
t1=$((t1-t0))
printColored.bash green "\n\n\n\t\t\t""$(basename "$0")"" ""$what"" ""$where"":\n"
printColored.bash green "\t---------------------------------------\n"
setTextAttributes.bash bold green
cat "$sFile"
setTextAttributes.bash
printColored.bash green "\t---------------------------------------\n"
printColored.bash yellow "\tIt took ""$(printSeconds.bash "$t1")""\n"
if [ $t1 -ge 13 ]; then
	Beep.sh 1 "Search for ""$what"" finished."
fi
#
# END
printf "\n\n\n"
# eof
