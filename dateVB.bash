#! /bin/bash
#
# F:
#
# Init:
usageLine="$(basename "$0")"" [args-for-date-command]"
aSystem="$(uname -s)"
if echo "$aSystem" | grep "Linux" > /dev/null; then
	aSystem="Linux"
else
	aSystem="UNIDENTIFIED"
fi
#			printf "\n\n\n\t\t\taSystem ='%s'\n\n\n" "$aSystem"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	if askYN.bash "Want to see \"man date\"?"; then
		man date
	fi
	printf "\n\n\n"
	exit 13
fi
#
# Main:
case "$aSystem" in
	"Linux")
		date $*
	;;
	*)
		printUsage.bash "$usageLine" "Unimplemented for aSystem='""$aSystem""'."
		exit 13
	;;
esac
#
# END:
#
# eof
