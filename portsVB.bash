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
getListening() {
	local usageLine="getListening [IP=localhost]"
	local IP="$1"
	local retCode=13
	if [ -z "$IP" ]; then
		IP=localhost
		# printUsage.bash "$usageLine" "Bad IP = '""$IP""'"
		# return 13
	fi
	# local CMD="sudo nmap -sT -O -Pn ""$IP"
	local CMD="sudo nmap -sT -Pn ""$IP"
	printColored.bash yellow "\t\t\t\t\t\t\t'""$CMD""'...\n"
	# sudo nmap -sT -O "$IP"
	$CMD
	retCode=$?
	#
	return $retCode
}
#
# Init:
clear
printf "\n\n\n"
usageLine="$(basename "$0")"" [IP=localhost]"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
#
# Main:
if [ $# -lt 1 ]; then
	doCMD "getListening ""$1" noStop 2
else
	while [ -n "$1" ]; do
		doCMD "getListening ""$1" noStop 2
		shift
	done
fi
# lsof -i
CMD="lsof -i # see used internet ports/files"
printColored.bash yellow "\t\t\t\t\t\t\t'""$CMD""'...\n"
CMD="lsof -i"
doCMD "$CMD" noStop 2
#
# END
printf "\n\n\n"
# eof
