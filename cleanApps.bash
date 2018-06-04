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
. "$(vbShellDir.bash)""/dirUse.fun"
. "$(vbShellDir.bash)""/humanBytes.fun"
#
removeFiles() {
	printColored yellow "\n\t\t\tRemoving '""$2""' in '""$1""' ...\n"
	find "$1" -name "$2" | while IFS= read -r aLine ; do
		if exists -f "$aLine"; then rm -fv "$aLine"; fi
	done
	printColored yellow "\t\t\tRemoving '""$2""' in '""$1""' done.\n\n"
}
#
emptyDir() {
	printColored yellow "\n\t\t\tEmptying '""$1""' in '""$2""'...\n"
	find "$2" -name "$1" | while IFS= read -r aLine ; do
		if exists -d "$aLine"; then rm -Rfv "$aLine"; mkdir -v "$aLine"; fi
	done
	printColored yellow "\t\t\tEmptying '""$1""' in '""$HOME""' done.\n\n"
}
#
# Init:
# clear
# printf "\n\n\n"
usageLine="$(basename "$0")"" [anIP, anIP, ...]""\n\n\tCleans VBlibs and workspaceEclipse\nat anIP (if given) or this computer."
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
dirCLEAN=$HOME/VBlibs/Apps
# read -p "             Check/ented root directory to clean: [$dirCLEAN]:  " answer
# if ! [ -z "$answer" ]; then dirCLEAN=$answer; fi
if ! exists -d "$dirCLEAN"; then
	printUsage.bash "$usageLine" "dirCLEAN = '""$dirCLEAN""' absent"
	exit 13
fi
#
#
# Main:
#
anIP="$1"
if [ ! -z "$anIP" ]; then
	while ! [ -z "$anIP" ]; do
		printColored yellow "\n\tPing-ing $anIP...   "
		if answer=$(ping -q -c 1 -W 1 "$anIP"); then
			printColored green "OK\n\n"
		else
			printColored red "No reply\n\n"
			if ! askProceed 0; then
				exit 13
			fi
		fi
		# ssh "$anIP" "PATH=$PATH:$HOME/VBlibs/Langs/shell; echo $PATH; sleep 3; ""$(basename "$0")"
		# ssh "$anIP" "PATH=$PATH:""~""/VBlibs/Langs/shell; echo $PATH; sleep 3; ""$(basename "$0")"
		ssh "$anIP" "PATH=$PATH:""~""/VBlibs/Langs/shell; ""$(basename "$0")"
		shift; anIP="$1"
	done
	exit 0
fi
#
dirCLEANlib=$HOME/VBlibs
kb0=$(dirUse "$dirCLEANlib")
#
emptyDir "bin" "$dirCLEAN"
emptyDir "makeOutDir" "$dirCLEAN"
removeFiles "$dirCLEAN" ".project"
removeFiles "$dirCLEAN" ".classpath"
removeFiles "$dirCLEAN" ".metadata"
removeFiles "$dirCLEAN" ".*.swp"
dirCLEAN=$HOME/VBlibs
removeFiles "$dirCLEAN" "6x*.mov"
removeFiles "$dirCLEAN" ".6x?.mov.*"
#
dirCLEANws=$HOME/workspaceEclipse
if exists -d "$dirCLEANws"; then
	rm -Rfv "$dirCLEANws"
	mkdir -v "$dirCLEANws"
fi
#
dirCLEANsh=$HOME/VBlibs/Langs/shell/shell
if exists -d "$dirCLEANsh"; then
	rm -Rfv "$dirCLEANsh"
fi
#
#
# kb1=$(du -k "$dirCLEANlib" | tail -1); kb1=${kb1/"/"*/""}; kb1=${kb1/ */""}
kb1=$(dirUse "$dirCLEANlib")
if isInteger "$kb0" && isInteger "$kb1"; then
	printf "\n\n\n\tbefore cleaning:\t\t %d\n\tafter  cleaning:\t\t %d\n\tgain = %s\n\n\n" $kb0 $kb1 "$(humanBytes $(( (kb0 - kb1) * 1024 )) )"
else
	printf "\n\n\n\tbefore cleaning:\t\t %s\n\tafter  cleaning:\t\t %s\n\n\n" "$kb0" "$kb1"
fi
#
# END
printf "\n\n\n"
# eof
