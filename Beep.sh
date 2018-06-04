#! /bin/bash
#
# Functions
vbShell=/home/vasyl/VBlibs/Langs/shell
vbShell=$HOME/VBlibs/Langs/shell
# . $vbShell/importAll.fun; importAll
. $vbShell/paPlay.fun
. $vbShell/isMAC.fun
#
usageLine="$(basename "$0") [h|Nrepeat] [aTextToESpeak]   (press any key to stop :-)"
#
#
aText=""
if [ "$2" != "" ]; then
	aText="$2"
fi
nRep=1
if [ $# -gt 0 ]; then
	arg1="$1"
	if [ ${arg1:0:1} = "-" ]; then
		printUsage.bash "$usageLine"
		exit 13
	fi
	if isInteger.bash $1; then
		nRep=$1
	else
		printUsage.bash "$usageLine" "Integer value expected for Nrepeat"
		exit 13
	fi
fi
#
cmdLine=$(checkPGM.sh "paplay")
errCode=$?
#
case "$HOSTNAME" in
	"goppi") errCode=13;;
esac
#
if [ $errCode -eq 0 ]; then
	# printf "\n\n\n\t\t\tFOUND paplay command :-)\n\n"
	aKey=""
	# for iR in $(seq $nRep)
	for((iR = 0; iR < nRep; iR++))
	do
		if [ $iR -ne 1 ]; then read -s -n 1 -t 1 aKey; fi
		if [ "$aKey" != "" ]; then
			break
		fi
		if [ "$aText" != "" ]; then
			eSpeakVB.bash "$aText"
		else
			if ! (paplay /usr/share/sounds/gnome/default/alerts/bark.ogg 2>/dev/null); then
				# (paPlay message new 2>/dev/null)
				# (paPlay noise 2>/dev/null)
				(paPlay camera shut 2>/dev/null)
				# paPlay camera shut
			fi
		fi
	done
else
	#printf "\n\n\n\t\t\tNO paplay command :-(\n\n"
	for ((iR=0; iR<nRep; iR++))
	do
		if [ "$aText" != "" ]; then
			eSpeakVB.bash "$aText"
		fi
		if pc=$(isMac); then say "beep"; else printf "\a"; fi
		sleep 1
	done
	
fi
#
# eof
