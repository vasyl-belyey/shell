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
. "$(vbShellDir.bash)""/stringContains.fun"
. "$(vbShellDir.bash)""/indexOf.fun"
. "$(vbShellDir.bash)""/parseOption.fun"
#
# Init:
usageLine="$(basename "$0")"" [hostName]"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
#
# Main:
# "https://www.whatismyip.com"
# 85.165.48.159
hostName="$1"; if [ -z "$hostName" ]; then hostName="$HOSTNAME"; fi
zFileName="$(dirName.bash "$0")""/""$hostName"".globalIP.txt"
if ! zIP="$(zFile.bash read "$zFileName")"; then
	zIP="85.165.48.159"
fi
#
pageDL="https://www.whatismyip.com/"
fileOut="$0"".log.txt"
CMD="wget -O ""$fileOut"" ""$pageDL"
if doCMD "$CMD" soft 2; then
	less "$fileOut"
else
	printColored.bash red "\n\n\n\t\t\tBrowse: '""$pageDL""'\n\n\n"
	printColored.bash yellow "Last time it was: '""$zIP""'\n\n\n"
fi
#
if askYNsilent "\t\t\tChange the last known value?"; then
	read -p "             Enter new global IP value [""$zIP""]  " answer
	if [ ! -z "$answer" ]; then zIP="$answer"; fi
fi
printColored.bash green "\n\t\t\tSaved: '""$(zFile.bash write "$zFileName" "$zIP")""' to '$zFileName'\n\n\n"
#
# END
# printf "\n\n\n"
# eof
