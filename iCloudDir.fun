#! /bin/bash
#
# Functions:
#
# . "doCMD.fun"
# . "exists.fun"
# . "askYN.fun"
# . "askYNsilent.fun"
# . "askProceed.fun"
# . "printFile.fun"
# . "isMac.fun"
# . "isInteger.fun"
# . "stringContains.fun"
# . "indexOf.fun"
# . "parseOption.fun"
# . "printSeconds.fun"
# . "printColored.fun"
# . "printColoredOpt.fun"
# . "isSudoer.fun"
# . "lsofVB.fun"
# . "cursorGoTo.fun"
# . "paPlay.fun"
# . "maxOf.fun"
# . "minOf.fun"
# . "dirName.fun"
# . "includeAll.fun"; (includeAll 2>/dev/null)
#
# Init:
iCloudDir() {
#	usageLine="$(basename "$0")"
#
# Checks:
#	if [ "$1" = "-" ]; then
#		printUsage.bash "$usageLine"
#		exit 13
#	fi
#
#
# Main:
# echo "\$HOME/Library/Mobile Documents/com~apple~CloudDocs"
echo "$HOME/Library/Mobile Documents/com~apple~CloudDocs"
# echo "~/Library/Mobile Documents/com~apple~CloudDocs"
#
# END
}
# eof
