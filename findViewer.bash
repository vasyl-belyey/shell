#! /bin/bash
#
# Functions:
writeLog() {
	printf "%s\n" "$1" > "$logName"
}
#
readLog() {
	cat "$logName"
}
#
#
usageLine="$(basename "$0")"" [viewFile [inForeGround]]"
#
logName0="$0"".log"
logName="$(dirName.bash .)""/""$(basename "$0")"".log"
###printf "%s\n%s\n" "$logName0" "$logName"; exit 13
if [ ! -f "$logName" ]; then
	cp -p "$logName0" "$logName"
fi
#
viewFile="$1"
#
if [ "$viewFile" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if [ ! -f "$viewFile" ]; then
	viewFile0=$(readLog)
	if [ -f "$viewFile0" ]; then
		askYN.bash "File '""$viewFile""' not found.  View log file '""$viewFile0""' ?"
		if [ $? -eq 0 ]; then
			viewFile="$viewFile0"
		else
			exit 13
		fi
	fi
fi
#
vList="ggv evince gs"
# Check if not pdf:
if [ "$viewFile" != "" ]; then
	sLen=${#viewFile}
	if [ $sLen -ge 4 ]; then
		extF="${viewFile:$((sLen-4)):4}"
		case "$extF" in
			".png") vList="eog";;
			".jpg") vList="eog";;
			"jpeg") vList="eog";;
			".bmp") vList="eog";;
			".BMP") vList="eog";;
			".txt") vList="less";;
			".avi") vList="totem";;
			".mp4") vList="totem";;
			".m4v") vList="totem";;
			".pls") vList="totem";;
			".flv") vList="totem";;
			"mpeg") vList="totem";;
			".rtf") vList="loffice";;
		esac
	fi
fi
#
#############	echo "'""$logName""'"; exit
#
for aViewer in $vList
do
	printf "aViewer = '%s'\n" "$aViewer"
	cmdLine=$(checkPGM.sh "$aViewer")
	errCode=$?
	if [ $errCode -eq 0 ]; then
		aMsg="EXISTS :-) as '""$cmdLine""'"
	else
		aMsg="absent :-("
	fi
	printf "\t\t\t%s\n" "$aMsg"
	if [ ! "$cmdLine" = "" ]; then break; fi
done
#
if [ ! "$cmdLine" = "" ]; then
	if [ "$cmdLine" = "less" ]; then
		$cmdLine "$viewFile"
	else
		clear
		if [ "$2" = "" ]; then
			$cmdLine "$viewFile" &
			sleep 3
			printColored.bash green "\n""$cmdLine"" is in background...\n"
		else
			$cmdLine "$viewFile"
		fi
	fi
	errCode=$?
	if [ $errCode -eq 0 ]; then
		writeLog "$viewFile"
	fi
else
	errCode=13
fi
#
checkErrorCode.sh $errCode
exit $errCode
#
# eof
