# . "$(vbShellDir.bash)""/isSudoer.fun"
# . "$(vbShellDir.bash)""/parseOption.fun"
# . "$(vbShellDir.bash)""/askYNsilent.fun"
# . "$(vbShellDir.bash)""/printColored.fun"
lsofVB() {
	# Main:
	local usageLine="lsofVB [-p portNo] [-h hostIP=localhost] [-u user]"
	local caller="$0"
	if [ "$1" = "-" ]; then echo "$usageLine"; return 13; fi
	local portNo="$(parseOption "-p" $*)"
	local hostIP="$(parseOption "-h" $*)"
		if [ -z "$hostIP" ]; then hostIP="$HOSTNAME"; fi
		if [ -z "$hostIP" ]; then hostIP="localhost"; fi
	local userName="$(parseOption "-u" $*)"
		if [ -z "$userName" ]; then userName="$USER"; fi
	local CMD; local zCMD; local dT="$(date +%s)"
# printf "args='%s'\n" "$*"
# printf "portNo='%s'\n" "$portNo"
# printf "hostIP='%s'\n" "$hostIP"
# printf "userName='%s'\n" "$userName"
# if [ "$caller" = "bash" ]; then return 13; else exit 13; fi
	# clear
	printf "\n\n\n"
	printf "\t lsofVB for '%s'@'%s'\n" "$userName" "$hostIP"
	#
	# checks:
	if [ ! -z "$portNo" ] && ! isInteger.bash "$portNo"; then
		echo "ERROR: portNo='""$portNo""' must be integer"
		echo "$usageLine"
		return 13
	fi
	printf "\n\n\n"
	#
	# lsof:
	CMD="lsof -i"
	printf "\t\t\t'%s'\n" "$CMD"
	$CMD 2>&1
	printf "\n\n\n"
	#
	# nmap:
	if isSudoer; then
		CMD="sudo nmap -sT -O ""$hostIP" # -O -> OS detection
		CMD="sudo nmap -sT ""$hostIP"
		#
		zCMD="$CMD"
		if [ ! -z "$portNo" ]; then zCMD="$zCMD"" | grep \"""$portNo""/\""; fi
		printf "\n\n\n\t\t\t'%s'\n" "$zCMD"
		#
		if [ ! -z "$portNo" ]; then
			$CMD | grep "$portNo""/" 2>&1
		else
			$CMD 2>&1
		fi
	fi
	printf "\n\n\n"
	#
	# jobs:
	# CMD="jobs -l"
	# printf "\t\t\t'%s'\n" "$CMD"
	# $CMD 2>&1
	#
	printColored green "\t\t\t\t\t\t\tIt took ""$(printSeconds.bash $(( $(date +%s) - dT )) )""\n"
	# service --status-all
	CMD="service --status-all"
	if askYNsilent "\t\t\tShow '""$CMD""'?" "yn" 1; then
		$CMD 2>&1
	fi
	#
	# END
	printColored green "\t\t\t\t\t\t\tIt lasted for ""$(printSeconds.bash $(( $(date +%s) - dT )) )""\n\t\t\t at ""$(date)""\n"
	printf "\n\n\n"
}
# eof
