#! /bin/bash
#
# Functions:
#
. includeAll.FUN
#
# Init:
clear
printf "\n\n\n"
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
# fil="vbFilterHTTP.html"; wget -O "${fil}" "${vbFilterHTTP}""?n=V%20B""&cam=ab0""&cam=ab1""&cam=ab2""&cam=ab3"; less "${fil}
fil=$(dirName "$0")/$(basename "$0")".html"
curl -o "${fil}" "${vbFilterHTTP}""?n=V%20B""&cam=ab0""&cam=ab1""&cam=ab2""&cam=ab3" \
&& less "${fil}" \
|| echo "ERR"
#
# END
printf "\n\n\n"
# eof
