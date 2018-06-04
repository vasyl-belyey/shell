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
# usageLine="$(basename "$0")"" [-F(oreground)] [-D workDir=\$HOME/VBlibs/Langs/matlab]"
usageLine="$(basename "$0")"" [-F(oreground)] [-D workDir=./]"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
#
# Main:
pc="$(uname -o)"
if [[ "$pc" =~ "Darwin" ]]; then
	CMD="/Applications/octave.app"
else
	if [[ "$pc" =~ "Linux" ]]; then
		CMD="octave --force-gui"
		if ! pc=$(parseOption -F $*); then
			CMD="$CMD"" &"
		fi
	else
		printUsage.bash "$usageLine" "Unimplemented for Windows."
		exit 13
	fi
fi
#
# if ! workDir=$(parseOption -D $*); then workDir=$HOME/VBlibs/Langs/matlab; fi
if ! workDir=$(parseOption -D $*); then workDir=$(pwd); fi
doCMD "cd $workDir" 1 1
# echo "'$CMD'"
doCMD "$CMD" 1 1
#
# END
# eof
