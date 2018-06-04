#! /bin/bash
#
# Init:
#
usageLine="$(basename "$0")"" color formatAsInPrintf [argsAsInPrintf]"
#
# Checks:
#
arg1="$1"
if [ "${arg1:0:1}" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if [ $# -lt 2 ]; then
	printUsage.bash "$usageLine" "Too few arguments"
	exit 13
fi
#
# main:
#
setTextAttributes.bash bold "$1"
arg1="$2"
shift; shift
printf "$arg1" $*
setTextAttributes.bash
#
# END
#
# eof
