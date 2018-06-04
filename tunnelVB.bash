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
timerVB() {
	if [ $# -gt 0 ]; then
		lastTime="$(date +%s)"
		printColored.bash blue "\t\t\t\t\t\t\ttimerVB started at ""$(date)"" ...\n"
	else
		local zT="$lastTime"
		lastTime="$(date +%s)"
		lastTimeDelta="$(printSeconds.bash $((lastTime - zT)))"
		printColored.bash green "\t\t\t\t\t\t\ttimerVB: it took ""$lastTimeDelta"" ...\n"
	fi
}
#
doExit() {
	local exitCode=$1
	if ! isInteger.bash "$exitCode"; then exitCode=0; fi
	printf "\n\n\n"
	exit $exitCode
}
#
selectServer() {
	local retVal=""
	local retCode=13
	case $nServers in
		1)
			retVal="${serverList[0]}"; retCode=0
		;;
		*)
		;;
	esac
	#
	echo $retVal
	return $retCode
}
#
selectPort() {
	local retVal=""
	local retCode=13
	case $nPorts in
		1)
			retVal="${portList[0]}"; retCode=0
		;;
		*)
			selectItem.bash "Select port" ${portList[*]}
			retCode=$?; retCode=$((retCode - 1))
			if [ $retCode -ge 0 ] && [ $retCode -lt $nPorts ]; then
				retVal=${portList[$retCode]}
				retCode=0
			else
				retCode=13
			fi
		;;
	esac
	#
	# echo $retVal
	aPort="$retVal"
	return $retCode
}
#
tunnelThrough() {
	local CMD="ssh -o \"ExitOnForwardFailure yes\" -o \"ServerAliveInterval 300\" ""$USER""@""$aServer"" -NR ""$aPort"":localhost:22"
	# local CMD=ssh -o \"ExitOnForwardFailure yes\" -o \"ServerAliveInterval 300\" $USER@$aServer -NR $aPort:localhost:22
	#
	printColored.bash yellow "CMD='""$CMD""'\n"
	if askYNsilent "\t\t\tTry the CMD ?"; then
		timerVB ON
		# $CMD
		# exeCMD.bash "watch ls" -13 "WATCH"
		# /etc/ssh/sshd_config :
		# AllowTcpForwarding yes
		# service ssh restart
		# (ssh -o "ExitOnForwardFailure yes" -o "ServerAliveInterval 300" USER@HOST -NR $TUNNEL_PORT:localhost:22 2>&1 ) > /dev/null
		ssh -o "ExitOnForwardFailure yes" -o "ServerAliveInterval 300" $USER@$aServer -NR $aPort:localhost:22
		eSpeakVB.bash "Connection to ""$aServer"" broken."
		timerVB
		Beep.sh 1 "It lasted ""$lastTimeDelta""."
	fi
}
#
connectTo() {
	local CMD="ssh -p ""$aPort"" ""$USER""@""$aServer"
	#
	printColored.bash yellow "CMD='""$CMD""'\n"
	if askYNsilent "\t\t\tTry the CMD ?"; then
		timerVB ON
		$CMD
		# exeCMD.bash "watch ls" -13 "WATCH"
		eSpeakVB.bash "Connection to ""$aServer"" broken."
		timerVB
		Beep.sh 1 "It lasted ""$lastTimeDelta""."
	fi
}
#
#
# Init:
clear
usageLine="$(basename "$0")"" command\n\tcommand = T | C\n\tT -> tunnel through accessible server\n\tC -> connect via the server"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	doExit 13
fi
#
case "$1" in
	"T")
	;;
	"C")
	;;
	*)
		printUsage.bash "$usageLine" "Bad or absent command = '""$1""'."
		doExit 13
	;;
esac
#
# Initialize servers:
serverList=()
nServers=${#serverList[*]}; serverList[$nServers]="fenchurch.esr.eiscat.no"
nServers=${#serverList[*]}
# select server:
if aServer=$(selectServer); then
	printColored.bash green "\t\t\t\t\t\t\t aServer = '""$aServer""'\n"
else
	printColored.bash red "\t\t\t\t\t\t\t aServer = '""$aServer""'\n"
	doExit 13
fi
#
# Initialize ports:
portList=()
nPorts=${#portList[*]}; portList[$nPorts]="13713"
nPorts=${#portList[*]}; portList[$nPorts]="8080"
nPorts=${#portList[*]}
# select server:
if selectPort; then
	printColored.bash green "\t\t\t\t\t\t\t aPort = '""$aPort""'\n"
else
	printColored.bash red "\t\t\t\t\t\t\t aPort = '""$aPort""'\n"
	doExit 13
fi
#
#
# Main:
#
case "$1" in
	"T")
		tunnelThrough
	;;
	"C")
		connectTo
	;;
	*)
		printUsage.bash "$usageLine" "Bad or absent command = '""$1""'."
		doExit 13
	;;
esac
#
#
# END
doExit 0
# eof
