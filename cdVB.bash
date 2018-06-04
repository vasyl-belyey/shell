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
. "$(vbShellDir.bash)""/paPlay.fun"
. "$(vbShellDir.bash)""/maxOf.fun"
. "$(vbShellDir.bash)""/minOf.fun"
. "$(vbShellDir.bash)""/includeAll.fun"
#
# Init:
printf "\n\n\n"
dirs=($HOME/VBlibs/Apps/phHM $HOME/VBlibs/Apps/BearingDirectionGrid $HOME/VBlibs/Apps/phApps/phPrisPrognose "$(pwd)")
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
selectItem.bash "Select work directory:" ${dirs[*]}
sel=$?; ((sel--))
if [ $sel -ge 0 ] && [ $sel -lt ${#dirs[*]} ]; then
	cd "${dirs[$sel]}"
	printColored green "\n\t$(pwd)\n\n"
else
	printColored red "\n\t\t\tInvalid selection sel = '$sel' :-(\n\n\n"
fi
#
# END
printf "\n\n\n"
# eof
