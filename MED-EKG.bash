#! /bin/bash
#
# Functions:
#
askForCopy() {
	local question="Ready?"
	local answer=""
	local jarFile="$(basename "$(pwd)")"
	local jarFileBackup="$jarFile"".$(date +%Y%m%d)"
	jarFile="$jarFile"".jar"
	jarFileBackup="$jarFileBackup"".jar"
	if [ -f "$jarFileBackup" ]; then
		printColored.bash green "\n\t\t\tBACKUP copy '""$jarFileBackup""' already exists.\n\n"
	else
		printColored.bash red "\n\t\t\tBACKUP copy '""$jarFileBackup""' does not exist.\n\n"
		# Beep.sh 2
		question="Create the BACKUP copy '""$jarFileBackup""' ?"
		if askYN.bash "$question" "yn" 1; then
			cp -p "$jarFile" "$jarFileBackup"
		fi
	fi
	if askYN.bash "Ready?"; then
		printColored.bash green "\n\n\n\t\t\tPROCEEDING...\n\n\n"
	else
		printColored.bash red "\n\n\n\t\t\tEXITING...\n\n\n"
		exit 13
	fi
}
#
USAGE() {
	printUsage.bash "$usageLine" "$1"
	# exit 13
}
#
printColored() {
	setTextAttributes.bash bold "$1"
	fmt="$2"
	shift; shift
	printf "$fmt" $*
	setTextAttributes.bash
}
#
getDevPath() {
	printf "%s\n" "$devDir""$devFile"
}
#
callMINICOM() {
	echo "iChoice = '""$iChoice""'"
	if [ -c "$devPath" ]; then
		#CMD="sudo minicom -c on -D ""$devPath"" -b 115200 -8"
		#############sudo useradd -G {group-name} username
		#############sudo usermod -a -G dialout $USER
		chOwn=0
		if [ ! -r "$devPath" ] || [ ! -w "$devPath" ]; then
			CMD="sudo chown ""$USER"" /dev/ttyACM0"
			exeCMD.bash "$CMD"; retCode=$?
			if [ $retCode -ne 0 ]; then exit 13; fi
			chOwn=1
		fi
		if [ ! -L /dev/ttyS80 ]; then
			sudo ln -s /dev/ttyACM0 /dev/ttyS80
		fi
		#
		local selItem
		if [ $iChoice -eq 0 ]; then
			selectItem.bash "Select action:" "Run minicom" "Run Eclipse" "Run MED_EKG_Pinhole.jar" "Compile (and run) MED_EKG_Pinhole.jar"
			selItem=$?
		else
			selItem=$iChoice
		fi
	echo "selItem = '""$selItem""'" # ; exit 13
		case $selItem in
			1)
				CMD="minicom -c on -D ""$devPath"" -b 115200 -8"
			;;
			2)
				CMD="eclipseRUN.bash 1" # BACKGROUND
				CMD="eclipseRUN.bash" # FOREGROUND
			;;
			3)
				#   CMD="minicom -c on -D ""$devPath"" -b 115200 -8"
				# CMD="printf \"\n\n\nUnimplemented selItem = ""$selItem""...\n\n\n\""
				# javaFile="$(dirName.bash ".")"
				javaFile="$(pwd)"
				# javaFile="$javaFile""/""MED_EKG_Pinhole.jar"
				javaFile="$javaFile""/""$(basename "$javaFile").jar"
				# CMD="java -jar ""$(dirName.bash ".")""/""MED_EKG_Pinhole.jar 1"
				CMD="java -jar ""$javaFile"
				printf "\n\n\n\t\t\tCMD = '%s'\n\n\n" "$CMD"
shift; exeCMD.bash "$CMD $*"; retCode=$?
# echo HERE; exit 13
				exit 13
			;;
			4)
				askForCopy
				CMD="ls"
			;;
			*)
				CMD="printf \"\n\n\nUnimplemented selItem = ""$selItem""...\n\n\n\""
			;;
		esac
		#
		exeCMD.bash "$CMD"; retCode=$?
		echo
		if [ $chOwn -ne 0 ]; then
			CMD="sudo chown root /dev/ttyACM0"
			exeCMD.bash "$CMD"; retCode=$?
			if [ $retCode -ne 0 ]; then exit 13; fi
			chOwn=0
		fi
		if [ $retCode -ne 0 ]; then exit 13; fi
		clear
	else
		printColored red "\n\n\n\t\t\t\tDevice '%s' not found/connected.\n\n\n" "$devPath"
		#
		case $iChoice in
			1)
				CMD="minicom -c on -D ""$devPath"" -b 115200 -8"
				USAGE "Option 1 (minicom: '""$CMD""') unavailable."
				exit 13
			;;
			2)
				eclipseRUN.bash
			;;
			5)
				eclipseRUN.bash "" "C"
			;;
			3)
				CMD="$(pwd)""/""$(basename "$(pwd)")"".jar"
				if [ -f "$CMD" ]; then
					printColored.bash green "\tRunning jar file '""$CMD""'...\n\n"
				else
					USAGE "Jar file '""$CMD""' does not exist."
					exit 13
				fi
				shift
				CMD="java -jar ""$CMD"" $*"
				printf "CMD = '%s'\n" "$CMD"
				# exit 13
				$CMD
			;;
			4)
				CMD="make; make clean"
				printf "\n\n\n\t\t\tRUN: '%s'\n\n\n" "$CMD"
				askForCopy
				# CMD="ls"
				# $CMD
				if make; then make clean; else printColored.bash red "\n\n\n\t\t\tERROR in make :-(\n\n\n"; Beep.sh; exit 13; fi
			;;
			*)
			USAGE "Bad iChoice = '""$iChoice""'"
			exit 13
			;;
		esac
		#
#		if [ $iChoice -eq 2 ]; then
#			eclipseRUN.bash
#		else
#			#askYN.bash "Run eclipse?"
#			#case $? in
#			#	0)
#				#	if askYN.bash "In background?"; then
#						eclipseRUN.bash
#				#	else
#				#		eclipseRUN.bash 1
#				#	fi
#			#	;;
#			#esac
#		fi
	fi
}
#
# End functions.
#
# Init:
#
usageLine="$(basename "$0")"" [iChoice:1-minicom, 2-Eclipse (default), 3-jar, 4-make, 5-Eclipse_C(pp)]"
iChoice=2
USAGE
if [ "$1" != "" ]; then
	if [ "$1" = "-" ]; then
		exit 13
	else
		iChoice="$1"
		if ! isInteger.bash "$iChoice"; then
			USAGE "Arg. must be integer from 1 to 5 - not '""$iChoice""'."
			exit 13
		else
			if [ $iChoice -lt 1 ] || [ $1 -gt 5 ]; then
				USAGE "Arg. must be integer from 1 to 5 - not '""$iChoice""'."
				exit 13
			fi
		fi
	fi
fi
devDir="/dev/"
devFile="ttyACM0"
devPath="$(getDevPath)"
printf "\n\t\t\tdevPath = '%s'\n" "$devPath"
#
# End Init.
#
# main:
#
callMINICOM $*
#
# End main.
#
# END:
###printf "\n\n\n\t\t\tSUCCESSFUL END.  Bye, %s.\n\n\n" "$USER"
printColored green "\n\n\n\t\t\t\t\t\t\tSUCCESSFUL END.  Bye, %s.\n\n\n" "$USER"
#
# eof
