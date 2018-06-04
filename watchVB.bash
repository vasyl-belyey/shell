#! /bin/bash
#
. "$(vbShellDir.bash)""/printSeconds.fun"
. "$(vbShellDir.bash)""/printColored.fun"
#
printf "\n\n\n"
usageLine="$(basename "$0")"" n CMD"
#
nTimeOut="$1"
if ! isInteger.bash $nTimeOut; then
	if [ "${nTimeOut:0:1}" = "-" ]; then
		printUsage.bash "$usageLine"
	else
		printUsage.bash "$usageLine" "Argument n must be integer"
	fi
	exit 13
fi
# Main:
for((i=0; ; i++)); do
	aLine="$("$2")"
	# nLines=( $aLine ); nLines=${#nLines[*]}
# printf "\t\t\t\t\t\t\t nLines = %s \n" "$nLines"
	# for((iLine = 0; iLine < nLines; iLine++)); do
	# 	printf "\r\033[K\n"
	# done
	# printf "\033[$nLinesA"
	# printf "\r%s" "$aLine"
	clear; printColored black "\n\n\n   " green "$(date)   " black "'" yellow "$2" black "' every " magenta "$nTimeOut sec.\n\n"
	printf "%s\n" "$aLine"
	answer=""
	for((iLine = nTimeOut; iLine > 0; iLine--)); do
		printColored green "\r""$(printSeconds $iLine)""\t\t"
		read -n 1 -s -t 1 answer
		case $answer in
			"q")
				break
			;;
			*)
			;;
		esac
	done
	# read -n 1 -s -t $nTimeOut answer
	case $answer in
		"q")
			break
		;;
		*)
		;;
	esac
done
#
# END:
printf "\n\n\n"
#
# eof
