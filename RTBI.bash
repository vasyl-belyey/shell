#! /bin/bash
#
# F:
#
#
# Init:
usageLine="$(basename "$0")"" [host = goppi | dynserv]"
hosts[0]="goppi"
hosts[1]="dynserv"
nHosts=${#hosts[*]}
#
# Checks:
case $# in
	0)
		selectItem.bash "Select a host's number to runRTBI on:" ${hosts[*]}
		retCode=$?
		if [ $retCode -lt 1 ] || [ $retCode -gt $nHosts ]; then
			printUsage.bash "$usageLine" "Unrecognized host's number ""$retCode"
			printf "Available hosts are:\n" "$hosts"
			for ((i=0; i<nHosts; i++)); do
				aHost="${hosts[$i]}"
				printf "\t%s\n" "$aHost"
			done
			printf "\n\n\n"
			Beep.sh 1
			exit 13
		fi
		aHost="${hosts[$((retCode-1))]}"
	;;
	1)
		fHost=1
		for((i=0; i<nHosts; i++)); do
			aHost="${hosts[$i]}"
			if [ "$aHost" = "$1" ]; then
				fHost=0
				break
			fi
		done
		if [ $fHost -ne 0 ]; then
			printUsage.bash "$usageLine" "Unrecognized host '""$1""'."; exit 13;
		fi
	;;
	*) printUsage.bash "$usageLine" "Too many arguments (""$#"" instead of 0 or 1)."; exit 13;;
esac
#
# Main:
printf "\n\n\n\t\t\tRunning RTBI on '%s'\n\n\n" "$aHost"
case "$aHost" in
	"goppi")
		theHost="eiscat@goppi.eiscat.uit.no"
		theCommand="ssh -X ""$theHost"
		theCommand="$theCommand"" cd vasyl/RTBI/Main; ./RTBI"
	;;
	"dynserv")
		theHost="eiscat@dynserv.eiscat.uit.no"
		theCommand="ssh -X eiscat@goppi.eiscat.uit.no ssh -X dynserv"
		###theCommand="$theCommand"" cd users/vasyl/RTBI/Main; ./RTBI"
		aHint="After connecting to ""$aHost"" enter '""cd users/vasyl/RTBI/Main; ./RTBI""'"
	;;
	*) printUsage.bash "$usageLine" "Unrecognized host '""$theHost""'."; exit 13;;
esac
#
# Run:
printf "\n\tRunning: '%s'...\n\n" "$theCommand"
if [ "$aHint" != "" ]; then
	setTextAttributes.bash bold red
	printf "\n\t%s\n" "$aHint"
	setTextAttributes.bash
	Beep.sh 3
fi
$theCommand
exitCode=$?
printf "\n\tDone: '%s'.  Exit code = %d\n\n" "$theCommand" $exitCode
#
# END:
printf "\n\n\n\t\t\tEnd of run on '%s'.\n\n" "$theHost"
###printf "\t\tSUCCESS.  (Press Ctrl-C to stop Beep.sh (and see if it works :-))\n\n\n"
checkErrorCode.sh $exitCode 1
###Beep.sh 1
#
# eof
