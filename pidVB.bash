#! /bin/bash
#
# F:
#
# Init:
usageLine="$(basename "$1")"" ProgramName"
#
# Checks:
if [ $# -lt 1 ]; then
	printUsage.bash "$usageLine" "Too few arguments."; exit 13
fi
#
# Main:
retVal=""
psStr="$(ps -C "$1")"
retCode=$?
#
iLine=-1
pID=""
iPID=0; retVal=""
echo "$psStr" | while IFS= read -r aLine ; do
	 echo "$iPID) '""$aLine""'"
	aLine=${aLine%%" "*}
	# aLine=${aLine##*" "}
	 echo ">>>>>>>""$iPID) '""$aLine""'"
	#
	if [ $iPID -lt 1 ]; then
		iPID=$((iPID+1))
	else
		if isInteger.bash "$aLine"; then
			if [ $iPID -eq 1 ]; then
				let retVal="$aLine"
			else
				let retVal="$retVal"" ""$aLine"
			fi
			iPID=$((iPID+1))
		fi
	fi
	 echo "'""$retVal""'"
done
 echo "0'""$retVal""'"
 echo "1'""$retVal""'"
#
printf "%s\n" "$retVal"
retCode=${#pID[*]}
if [ $retCode -gt 0 ]; then retCode=0; else retCode=13; fi
exit $retCode
#
# End:
#
# eof
