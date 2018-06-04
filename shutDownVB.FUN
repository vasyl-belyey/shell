# ! /bin/bash
#
# Functions:
#
# . "$(vbShellDir.bash)""/doCMD.fun"
# . "$(vbShellDir.bash)""/exists.fun"
# . "$(vbShellDir.bash)""/askYN.fun"
. askYNsilent.fun
# . "$(vbShellDir.bash)""/askProceed.fun"
# . "$(vbShellDir.bash)""/printFile.fun"
. "$(vbShellDir.bash)""/isMac.fun"
. "$(vbShellDir.bash)""/parseOption.fun"
. "$(vbShellDir.bash)""/indexOf.fun"
. "$(vbShellDir.bash)""/isInteger.fun"
# . "$(vbShellDir.bash)""/stringContains.fun"
#
# Init:
usageLine="$(basename "$0")"" [-r -> reboot, not down] [-nM nMinutesBeforeShutDown=1]"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	# exit 13
	return 13
fi
#
# local nM="$1" CMD=""
if ! nM=$(parseOption "-nM" $*) || ! isInteger "$nM" || [ $nM -le 0 ]; then
	nM=1
fi
#
# if isReboot=$(parseOption "-r" $*); then isReboot=1; else isReboot=0; fi
# echo "$isReboot"; return 13
CMD=""
#
# Main:
# if askYNsilent "\t\t\tProceed to shutdown?"; then
	if CMD=$(isMac); then
		# local tOFF=$(date +%s)
		tOFF=$(date +%s)
		# date -r $tOFF
		((tOFF += nM * 60))
		# date -r $tOFF
		tOFF=$(date -r "$tOFF" +"%H:%M")
		# printf "$tOFF\n"
		CMD="nohup sudo shutdown -h $tOFF"
	else
		if CMD=$(parseOption -r $*); then
			CMD="sudo reboot"
		else
			CMD="nohup sudo shutdown -P +$nM"
		fi
	fi
	#
	if askYNsilent "\n\n\n\t\t\t Confirm the CMD='$CMD'?" "ny"; then
		return 13
	else
		printf "\n\n\n"
		($CMD)
		printf "\n\n\n"
		exit
	fi
	#
# fi
#
# END
# eof
