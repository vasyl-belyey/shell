#! /bin/bash
#
# Functions
printManual() {
	printf "\n\n\n\t\t\t>>>>>>>>>>>>> XBee Manual VB <<<<<<<<<<<<<\n"
	# aCMD:
	xbCMD="Ctrl-A E (local echo ON/OFF)"
	printf "\t\t\t%s\n" "$xbCMD"
	# aCMD:
	xbCMD="Ctrl-A X (exit minicom)"
	printf "\t\t\t%s\n" "$xbCMD"
	# xCMD:
	xbCMD="+++ (get connected)"
	printf "\t%s\n" "$xbCMD"
	# xCMD:
	xbCMD="ATRE   (reset to factory settings)"
	printf "\t%s\n" "$xbCMD"
	# xCMD:
	xbCMD="ATID [0->FFFE]   (PAN ID)"
	printf "\t%s\n" "$xbCMD"
	# xCMD:
	xbCMD="ATMY [1|2]   (MY address, 1 => COMMAND)"
	printf "\t%s\n" "$xbCMD"
	# xCMD:
	xbCMD="ATDH [0]   (destination address high)"
	printf "\t%s\n" "$xbCMD"
	# xCMD:
	xbCMD="ATDL [1|2]   (destination address low)"
	printf "\t%s\n" "$xbCMD"
	#
	printf "\t\t\t<<<<<<<<<<<<< XBee Manual VB <<<<<<<<<<<<<\n\n\n\n"
	#
	findViewer.bash ./22AT_Commands.pdf &
	findViewer.bash ./90000982_A.pdf &
	#
	askYN.bash "Ready to connect to XBee ?"
	if [ $? -ne 0 ]; then exit 13; fi
}
#
#
# Init:
clear
usageLine="$(basename "$0")"
case "$HOSTNAME" in
	*)
		printf "\n\n\n\t\t\tUNRECOGNIZED HOSTNAME = '%s'\n\n\n" "$HOSTNAME"
		sCommands[0]="minicom"
	;;
esac
nCommands=${#sCommands[*]}
# checks:
if [ $# -ge 1 ]; then # just a template for help
	arg1="$1"
	if [ "$arg1" = "-" ]; then
		printUsage.bash "$usageLine"
		exit 13
	fi
fi
#
CMD="/home/vasyl/Downloads/Install/CoolTerm/CoolTermLinux/CoolTerm"
#
# ECLIPSE:
askYN.bash "Run eclipse?"
if [ $? -eq 0 ]; then
	#/home/vasyl/Downloads/Install/Eclipse-32/eclipse/eclipse &
	eclipseRUN.bash
fi
#
for ((iCmd=0; iCmd<nCommands; iCmd++))
do
	CMD="${sCommands[$iCmd]}"
	if [ -x "$CMD" ]; then
		printf "\n\n\n\t\t\tTrying '%s' command...\n\n" "$CMD"
		sudo $CMD
	else
		#CMD="$()"; exitCode=$?
		if checkPGM.sh "$CMD"; then
			printf "\n\n\n\t\t\tTrying '%s' command...\n\n" "$CMD"
			printManual
			sudo $CMD
		else
			printf "\n\tAbsent '%s' command.\n" "$CMD"
		fi
	fi
done
#
# eof
