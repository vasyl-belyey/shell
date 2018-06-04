#! /bin/bash
#
# Functions:
#
# Init:
usageLine="$(basename "$0")"" osName"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if [ $# -lt 1 ]; then
	printUsage.bash "$usageLine" "Argument 'osName' not given."
	exit 13
fi
#
#
# Main:
retVal="$(uname -s)"
if [[ "$retVal" =~ "$1" ]]; then
	retCode=0
else
	retCode=13
fi
#
# END
echo "$retVal"
exit $retCode
# eof
