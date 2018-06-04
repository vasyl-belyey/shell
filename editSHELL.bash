#! /bin/bash
#
# F:
. doCMD.fun
. exists.fun
. askYN.fun
. askYNsilent.fun
. "$homePrefix""askProceed.fun"
. "$homePrefix""printFile.fun"
. "$homePrefix""isMac.fun"
. "$homePrefix""stringContains.fun"
. "$homePrefix""parseOption.fun"
. "$homePrefix""printColored.fun"
. "$homePrefix""printSeconds.fun"
. "$homePrefix""isSudoer.fun"
. "$homePrefix""lsofVB.fun"
. "$homePrefix""cursorGoTo.fun"
. "$homePrefix""paPlay.fun"
#
# Init:
usageLine="$(basename "$0")"" aSHELFileName"
bashDir="$(vbShellDir.bash)"
bashName="$1"
#
clear
#
# Checks:
if [ "$bashName" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
else
	if [ "$bashName" = "" ]; then
		aComment="No aSHELFileName given."
		printUsage.bash "$usageLine" "$aComment"
		exit 13
	fi
fi
#
if ! exists -f "$bashName"; then
	bashName="$bashDir""/""$bashName"
else
	if ! stringContains "$bashName" "/"; then
		bashName="$(pwd)""/""$bashName"
	fi
fi
if ! exists -f "$bashName"; then
	aComment="File '""$bashName""' does not exist."
	if askYN.bash "$aComment""  Create new? "; then
		# bashName="$(vbShellDir.bash)""/""$bashName"
		templateStr="#! /bin/bash\n#\n# Functions:\n#\n"
homePrefix="$(vbShellDir.bash)"
homePrefix="${homePrefix/"$HOME"/~}""/"
		#
		templateStr="$templateStr"". \"doCMD.fun\"""\n"
		templateStr="$templateStr"". \"exists.fun\"""\n"
		templateStr="$templateStr"". \"askYN.fun\"""\n"
		templateStr="$templateStr"". \"askYNsilent.fun\"""\n"
		templateStr="$templateStr"". \"askProceed.fun\"""\n"
		templateStr="$templateStr"". \"printFile.fun\"""\n"
		templateStr="$templateStr"". \"isMac.fun\"""\n"
		templateStr="$templateStr"". \"isInteger.fun\"""\n"
		templateStr="$templateStr"". \"stringContains.fun\"""\n"
		templateStr="$templateStr"". \"indexOf.fun\"""\n"
		templateStr="$templateStr"". \"parseOption.fun\"""\n"
		templateStr="$templateStr"". \"printSeconds.fun\"""\n"
		templateStr="$templateStr"". \"printColored.fun\"""\n"
		templateStr="$templateStr"". \"printColoredOpt.fun\"""\n"
		templateStr="$templateStr"". \"isSudoer.fun\"""\n"
		templateStr="$templateStr"". \"lsofVB.fun\"""\n"
		templateStr="$templateStr"". \"cursorGoTo.fun\"""\n"
		templateStr="$templateStr"". \"paPlay.fun\"""\n"
		templateStr="$templateStr"". \"maxOf.fun\"""\n"
		templateStr="$templateStr"". \"minOf.fun\"""\n"
		templateStr="$templateStr"". \"dirName.fun\"""\n"
		#
		templateStr="$templateStr""# . \"includeAll.fun\"""; (includeAll 2>/dev/null)\n"
		#
		templateStr="$templateStr""#\n# Init:\nusageLine=\"\$(basename \"\$0\")\"\n#\n# Checks:\n"
		templateStr="$templateStr""if [ \"\$1\" = \"-\" ]; then\n\tprintUsage.bash \"\$usageLine\"\n\texit 13\nfi\n"
		templateStr="$templateStr""#\n#\n# Main:\n#\n# END\n# eof"
		printf "$templateStr" > "$bashName"
		vi "$bashName"
		chmod +x "$bashName"
	else
		printUsage.bash "$usageLine" "$aComment"
		exit 13
	fi
fi
#
# Main:
cd "$HOME"
answer="edit"
lastArg=""
timeOut=1
while [ "$answer" != "q" ]; do
	if [ "$answer" != "a" ]; then
		CMD="vi ""$bashName"
		printColored.bash yellow "\t\t\tOpening '""$bashName""'...\n'""$CMD""'\n"
		vi "$bashName"
		printColored.bash green "\n\n\n\t\t\tEdited '""$bashName""'.\n"
		#
		aComment="   Try '""$bashName""' ?"
		askYN.bash "$aComment"
		exitCode=$?
	else
		exitCode=0
	fi
	if [ $exitCode -eq 0 ]; then
		read -p "          Enter argument [""$lastArg""]: " answer
		if [ "$answer" != "" ]; then
			lastArg="$answer"
		else
			if [ "$lastArg" != "" ]; then
				if askYN.bash "             Forget lastArg '""$lastArg""' ?"; then
					lastArg=""
				fi
			fi
		fi
		# printColored.bash magenta "DEBUG: answer: '""$answer""',  lastArg: '""$lastArg""'\n"
		if [ "$lastArg" = "" ]; then
			printColored.bash yellow "\t\t\tDOING: '""$bashName""' in ""$timeOut"" sec...\n"; sleep $timeOut
			CMD=$bashName
		else
			printColored.bash yellow "\t\t\tDOING: '""$bashName"" ""$lastArg""' in ""$timeOut"" sec...\n"; sleep $timeOut
			# $bashName "$lastArg"
			CMD="$bashName $lastArg"
		fi
		$CMD
		exitCode=$?
		#
		if [ $exitCode -eq 0 ]; then
			aColor="green"
		else
			aColor="red"
		fi
		# printColored.bash magenta "DEBUG: aColor: '""$aColor""'\n"
		printColored.bash "$aColor" "\n\t\t\tTESTING done.  exitCode = '""$exitCode""'.\n"
	fi
	read -p "Press ENTER to load it again or 'q' to Quit or 'a' to try Again or 'e' to leave '""$(basename "$0")""' but keep Editing: " answer
	if [ "$answer" = "e" ]; then
		printColored.bash green "\n\n\n\t\t\tBye, ""$USER"".  Suggested command:\n'""$CMD""; checkErrorCode.sh \$?'\n\n\n"
		vi "$bashName"
		exit 0
	fi
done
#
# END
printf "\n\n\n"
# eof
