#! /bin/bash
#
# Functions:
isMac() {
        local retVal="$(uname -s)"
        local retCode
        if [[ "$retVal" =~ "Darwin" ]]; then retCode=0; else retCode=13; fi
        #
        # echo "$retVal"
        return $retCode
}
#
# Init:
usageLine="$(basename "$0")"" aPhrase [nRepeat=(1) [fDoNotReplaceByBeep.sh]]"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
aPhrase="$1"
#
nRepeats="$2"
if ! isInteger.bash "$nRepeats"; then
	nRepeats=1
else
	if [ $nRepeats -lt 1 ]; then
		nRepeats=0
	fi
fi
#
# Main:
for((i = 0; i < nRepeats; i++)); do
	# Speak it:
	if isMac; then
		say "$aPhrase"
	else
		espeak -a 999 -p 0 -s 60 "$aPhrase" 2>/dev/null # &
	fi
	exitCode=$?
	if [ $exitCode -ne 0 ]; then
		if [ "$3" = "" ]; then
			Beep.sh
		fi
	fi
	# Stop on any key pressed:
	if [ $((i+1)) -ge $nRepeats ]; then
		answer=""
		# read -rs -t 0 -n 1 answer
		read -s -t 0 -n 1 answer
		if [ "$answer" != "" ]; then
			# echo $answer
			break
		fi
	fi
done
#
# END
# eof
