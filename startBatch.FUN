#! /bin/bash
#
# Functions:
#
#
# Init:
# usageLine="$(basename "$0")"
#
# Checks:
# if [ "$1" = "-" ]; then
# 	printUsage.bash "$usageLine"
# 	exit 13
# fi
#
#
# Main:
stopWatch.bash -h14
stopWatch.bash -h24
temperatureWatchDog.bash
#
echo ". fgVB.FUN"
#
# END
# eof
