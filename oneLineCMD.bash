#! /bin/bash
#
# Functions:
#
# Init:
usageLine="$(basename "$0")"" aCommand"
#
showOneLine=1
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
CMD="$*"
printColored.bash yellow "\n\t\t\tDoing CMD '""$CMD""'...\n"
#
# Main:
t0=$(date +%s)
$CMD | while IFS= read -r aLine ; do
        nCols="$(terminalSize.bash C)"
        nCols1=$((nCols-1))
        fmt="%-""$nCols1""s"
        if [ $showOneLine -ne 0 ]; then
                fmt="\r""$fmt""\r"
        else
                fmt="$fmt""\n"
        fi
        ### echo "'$fmt'"; exit13
        setTextAttributes.bash bold green
        #
        aLine="${aLine:0:nCols1}"
        #
        printf "$fmt" "$aLine"
        setTextAttributes.bash
done
retCode=$?
#
# END
if [ $retCode -eq 0 ]; then
	printColored.bash green "\n\t\t\tCMD '""$CMD""' done for ""$(printSeconds.bash $(($(date +%s) - t0)) )""\n"
else
	printColored.bash red "\n\t\t\tCMD '""$CMD""' failed after ""$(printSeconds.bash $(($(date +%s) - t0)) )"" with ERROR ""$retCode""\n"
fi
# eof
