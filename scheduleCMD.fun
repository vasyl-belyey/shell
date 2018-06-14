# . "$(vbShellDir.bash)""/parseOption.fun"
# . "$(vbShellDir.bash)""/printColored.fun"
# . "$(vbShellDir.bash)""/indexOf.fun"
scheduleCMD() {
echo "scheduleCMD: args[""$#""] = ""$*"
	local usageLine="scheduleCMD aCommand [-Y YYYY] [-M MM] [-D DD] [-t hh:mm:ss || -t delaySECONDS]"
	local caller="$0"
	local retCMD; local retCode=13; local tStart=""; local iIndex; local aColor="red"
		if [ "$caller" = "bash" ]; then retCMD="return"; else retCMD="exit"; fi
	#
	local CMD="$1"
	if [ -z "$CMD" ]; then
		printColored red "\n\n\n\tERROR in scheduleCMD: No command given.\n"
		printColored white "\t\t\tUSAGE:\n""$usageLine""\n\n\n"
		$retCMD $retCode
	fi
	local tArg="$(parseOption -t $*)"
	#
	# make up tStart:
	if [ -z "$tArg" ]; then
		tStart=""
	else
		iIndex=$(indexOf "$tArg" ":")
		case "$iIndex" in
			*)
				tStart=$(( $(date +%s) + tArg ))
			;;
		esac
	fi
	#
	if [ -z "$tStart" ]; then tStart=$(date +%s); fi
	# date -d 01/01/"$aYear" +%s
	# date -u -d @${i} +"%T"
	printColored yellow "\n\t\tScheduled at ""$(date -d @"$tStart" +%T)""\n"
	while [ $tStart -gt $(date +%s) ]; do
		aColor="green"
		if [ $(( tStart - $(date +%s) )) -gt 13 ]; then aColor="yellow"; fi
		if [ $(( tStart - $(date +%s) )) -gt 60 ]; then aColor="red"; fi
		printColored "$aColor" "\r\t\t\t""$(printSeconds.bash $(( tStart - $(date +%s) )) )""\t\t"
		sleep 1
	done
	printColored green "\n\t\tStarting  at ""$(date +%T)""\n"
	#
	$CMD
	retCode=$?
	#
	$retCMD $retCode
}
