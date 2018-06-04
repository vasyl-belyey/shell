#! /bin/bash
#
# Functions:
#
checkErrorCode() {
	if [ $errCode -ne 0 ]; then
		printColored.bash red "\n\n\n\t\t\tERROR ""$errCode""\n\n\n"
		exit 13
	fi
}
#
# Init:
clear
prefixIP="10.0.0."
uName="$USER"
locIP="29"
usageLine="$(basename "$0")"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
#
# Main:
#
selectItem.bash "   Select target:" "LOCAL" "fenchurch.esr.eiscat.no"
errCode=$?
case $errCode in
	1)
	;;
	2)
		prefixIP="fenchurch.esr.eiscat."
		locIP="no"
	;;
	*)
		printColored.bash red "\n\n\n\t\t\tBAD selection\n\n\n"
		exit 13
	;;
esac
#
answer="";
read -p "          Enter/check target's IP prefix: [""$prefixIP""] " answer
if [ "$answer" != "" ]; then prefixIP="$answer"; fi
#
answer="";
read -p "          Enter/check target's local IP suffix: [""$locIP""] " answer
if [ "$answer" != "" ]; then locIP="$answer"; fi
#
printColored.bash green "\n\n\n\t\t\tCopying TO target...\n"
syncDirs.bash ~/VBlibs/ "$uName""@""$prefixIP""$locIP":~/VBlibs/
errCode=$?
checkErrorCode
if askYN.bash "          Copy FROM target?"; then
	printColored.bash green "\n\n\n\t\t\tCopying FROM target...\n"
	syncDirs.bash "$uName""@""$prefixIP""$locIP":~/VBlibs/ ~/VBlibs/
	errCode=$?
	checkErrorCode
fi
#
printf "\n\n\n"
exit 0
#
syncDirs.bash ~/workspaceEclipseZ/ "$uName""@""$prefixIP""$locIP":~/workspaceEclipseZ/
errCode=$?
checkErrorCode
syncDirs.bash "$uName""@""$prefixIP""$locIP":~/workspaceEclipseZ/ ~/workspaceEclipseZ/
errCode=$?
checkErrorCode
#
# END
# eof
