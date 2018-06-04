#! /bin/bash
#
# F:
#
#
# Init:
usageLine="$(basename "$0")"
#
# Checks:
#
# Main:
clear
printf "\n\n\n"
# Select port type:
selectItem.bash "Select port type:" "USB" "USB RS-232" "LAN"
case $? in
	1) 
		CMD="sudo minicom -D /dev/ttyUSB0"
		checkErrorCode.sh "$CMD" 1
	;;
	2) 
		# try 1
		CMD="tail -f /var/log/messages" # http://ubuntuforums.org/showthread.php?t=1241683
		checkErrorCode.sh "$CMD" 1
		#
		# try 2
		CMD="sudo minicom -D /dev/bus/usb/003/046"
		checkErrorCode.sh "$CMD" 1
		if [ $? -ne 0 ]; then
			CMD="ls -l /dev/bus/usb/003/"
			checkErrorCode.sh "$CMD" 1
		fi
	;;
	3)
		CMD="nmap"
		if CMDr=$(checkPGM.sh "$CMD"); then
			CMD="$CMDr"
			checkErrorCode.sh "$CMD" 1
		else
			printf "'%s' absent.\n" "$CMD"
			CMD="nc"
			if CMDr=$(checkPGM.sh "$CMD"); then
				for ((iPort=1; iPort<1024; iPort++)); do
					#CMD="$CMDr"" -zv 127.0.0.1 ""$iPort"
					#CMDs="$CMD"" > /dev/null"
					#if $CMDs; then
						#$CMD
					#fi
					CMDs="$CMD"" -zv 127.0.0.1 ""$iPort"
					retVal=$($CMDs 2>/dev/null)
					retCode=$?
					###printf "CMD='%s', retCode=%d\n" "$CMDs" $retCode
					if [ $retCode -eq 0 ]; then
						printf "\t\t\tSUCCESS: port %d, retVal='%s'\n" $iPort "$retVal"
					fi
				done
			fi
		fi
		###
		CMD="dmesg"
		if CMDr=$(checkPGM.sh "$CMD"); then
			CMDs="$CMD"" | grep tty"
			###checkErrorCode.sh "$CMDs" 1
			printf "\n\n\n\t\t\tDoing '%s'...\n" "$CMDs"
			"$CMDs"
			dmesg | grep tty
		fi
	;;
	*) printUsage.bash "$usageLine" "Unrecognized port type."; exit 13;;
esac
#
printf "\n\n\n"
#
# eof
