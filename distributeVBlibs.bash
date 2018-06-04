#! /bin/bash
#
# Functions:
#
. doCMD.fun
. "$(vbShellDir.bash)""/exists.fun"
. "$(vbShellDir.bash)""/askYN.fun"
. askYNsilent.fun
. askProceed.fun
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
# . "$(vbShellDir.bash)""/includeAll.fun"; (includeAll 2>/dev/null)
#
. name2ip.fun
. isIP.fun
#
# Init:
usageLine="$(basename "$0")"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
#
# Main:
nTRG=$#
for((i=0; i<nTRG; i++)); do
	ipTRG="$1"
	if [ $(indexOf "$ipTRG" "gs://") -ne 0 ] && ! isIP "$1"; then ipTRG=$(name2ip "$1"); fi
	printColored blue "\n\t\t\tNext target " yellow "$1" white " = " green "'$ipTRG'" blue ": \n"
	if ! askYNsilent "\t\t\t Proceed?"; then break; fi
	if [ "$ipTRG" = "$gdVBlibsID" ]; then
		if askYNsilent "\t\t\t Synching with Google Drive (gdVBlibsID):  upload?"; then
			CMD="gdrive sync upload --keep-local $HOME/VBlibs/ $ipTRG"
		else
			CMD="gdrive sync download --keep-remote $ipTRG $HOME/VBlibs/"
		fi
		doCMD "$CMD" 1 1
	else
		if [ $(indexOf "$ipTRG" "gs://") -eq 0 ]; then
			syncDirs.bash ~/VBlibs/ $ipTRG/VBlibs/
		else
			syncDirs.bash ~/VBlibs/ $ipTRG:VBlibs/
		fi
		if askYNsilent "             Clean '$ipTRG'?" "yn" 1; then cleanApps.bash $ipTRG; fi
	fi
	shift
done
#
# END
# eof
