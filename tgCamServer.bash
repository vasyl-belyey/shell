#! /bin/bash
#
# Functions:
#
. "doCMD.fun"
. "exists.fun"
. "askYN.fun"
. "askYNsilent.fun"
. "askProceed.fun"
. "printFile.fun"
. "isMac.fun"
. "isInteger.fun"
. "isIP.fun"
. "name2ip.fun"
. "stringContains.fun"
. "indexOf.fun"
. "parseOption.fun"
. "printSeconds.fun"
. "printColored.fun"
. "printColoredOpt.fun"
. "isSudoer.fun"
. "lsofVB.fun"
. "cursorGoTo.fun"
. "paPlay.fun"
. "maxOf.fun"
. "minOf.fun"
. "dirName.fun"
# . "includeAll.fun"; (includeAll 2>/dev/null)
# Functions:
doReport() {
	if ! [ -d "$pathCam" ]; then
		echo "not installed"
	else
		if ! pc=( $(ps -C java >/dev/null) ); then
			echo "not running"
		else
			echo "$PLACENAM"
			echo "${pc[6]}"
			# printColored green "$pc\n"
		fi
	fi
}
#
# Init:
modeMax=1
usageLine="$(basename "$0")"" [--sleep tSleep (between receptions)] [--port portNo (default=13717)] [--pathCam (=\$HOME/VBlibs/Apps/PinHoleCamera)]\
 [--ask ipCAM(=\$tgCam00)] [--mode nMode (=0)] [--ipME ipME(=localhost)] \n\n\
	Echoes \n   either \n\
\"not installed\" \n\
   or \n\
\"not running\" \n\
   or \n\
\"running\" \n\
	in response to 'reportStatus' request. \n\
	"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if ! tSleep=$(parseOption "--sleep" $*); then
	tSleep=3
fi
if ! isInteger "$tSleep" || [ "$tSleep" -le 0 ]; then
	printUsage.bash "$usageLine" "Invalid arg --sleep = '$tSleep' - must be positive integer."
	exit 13
fi
#
if ! portNo=$(parseOption "--port" $*); then
	portNo=13717
fi
if ! isInteger "$portNo" || [ "$portNo" -le 0 ]; then
	printUsage.bash "$usageLine" "Invalid arg --sleep = '$portNo' - must be positive integer."
	exit 13
fi
#
if ! pathCam=$(parseOption "--pathCam" $*); then
	pathCam=$HOME/VBlibs/Apps/PinHoleCamera
fi
#
if ipME=$(parseOption "--ipME" $*); then
	if ! isIP "$ipME"; then ipME=$(name2ip "$ipME"); fi
else
	ipME="localhost"
fi
#
if ipCAM=$(parseOption "--ask" $*) && ! isIP "$ipCAM"; then
	ipCAM=$(name2ip "$ipCAM")
fi
#
if ! nMode=$(parseOption "--mode" $*); then
	nMode=0
fi
if ! isInteger "$nMode" || [ "$nMode" -lt 0 ] || [ "$nMode" -gt $modeMax ]; then
	printUsage.bash "$usageLine" "Invalid arg --mode = '$nMode' - must be a non-negative integer between 0 and $modeMax."
	exit 13
fi
#
#
# Main:
if [ -z "$ipCAM" ]; then
	coproc netcat -l $ipME "$portNo"
	while read -r aRequest; do
		echo
		case "$nMode" in
			1)
				case "$aRequest" in
					reportStatus) doReport ;;
					"nMode=0")
						nMode=0
						printColored green "Okay\n"
					;;
					qill)
						printColored green "kill-ing myself PID = " white "$COPROC_PID\n"
						kill "$COPROC_PID"
						exit
					;;
					*)
						# echo
						# ($aRequest)
						eval $aRequest
						retCode=$?
						# echo
						case "$retCode" in
							0)
							;;
							127)
								printf "$aRequest"
							;;
							*)
								printColored red "ERROR $retCode: '$aRequest'\n"
							;;
						esac
					;;
				esac
			;;
			0)
				echo
				case "$aRequest" in
					reportStatus) doReport ;;
					watchMPEG)
						for((i=0;i<13;i++)); do
							sleep 3
							ls -l $HOME/images/*/*.mpeg
						done
					;;
					qill)
						printColored green "kill-ing myself PID = " white "$COPROC_PID\n"
						kill "$COPROC_PID"
						exit
					;;
					"nMode=1")
						nMode=1
						printColored yellow "Okay\n"
					;;
				esac
				echo
			;;
		esac
		echo
	done <&${COPROC[0]} >&${COPROC[1]}
else
	# printColored yellow "$0 $* \n\n"
	# if ! retVal=$(echo "reportStatus" | netcat $ipCAM $portNo); then
	# 	# printColored red "ERR \n\n"
	# 	exit 13
	# else
	# 	printColored green "'$retVal'\n"
	# fi
	#  coproc netcat $ipCAM $portNo
	# while read -r aRequest; do
	# done <&${COPROC[0]} >&${COPROC[1]}
	# echo "reportStatus" >&${COPROC[1]}
	#
	CMD=". .bash_aliases; if ! ps -C tgCamServer.bash; then (nohup tgCamServer.bash --ipME $ipCAM > /dev/null &); fi"
	ssh $tgCam00 "$CMD"
	# if ! exeCMD.bash "echo WAIT..." 7 header; then
		sleep 7
	# fi
	printf "\n\n\n\t\t\tReady.\ntell 'reportStatus' 'nMode=1' 'watchMPEG'\n\n\n"
	netcat $ipCAM $portNo
fi
#
#
# END
# eof
