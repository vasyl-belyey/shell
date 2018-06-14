#! /bin/bash
#
#       Attribute codes:
#       00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
#       
#       Text color codes:
#       30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
#       
#       Background color codes:
#       40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
#
# Functions:
. isInteger.fun
#
getColorName() {
	local retVal
		cNum=$1
		case $((cNum%8)) in
			0) retVal="black";;
			1) retVal="red";;
			2) retVal="green";;
			3) retVal="yellow";;
			4) retVal="blue";;
			5) retVal="magenta";;
			6) retVal="cyan";;
			7) retVal="white";;
			*) retVal="white";;
		esac
	printf "$retVal"
}
#
getColorNum() {
	local retVal
		case "$1" in
			"black") retVal=0;;
			"red") retVal=1;;
			"green") retVal=2;;
			"yellow") retVal=3;;
			"blue") retVal=4;;
			"magenta") retVal=5;;
			"cyan") retVal=6;;
			"white") retVal=7;;
			*) exit 13;;
		esac
	printf "$retVal"
}
#
#
if [ $# -lt 1 ]; then
	printf "\e[0m"
	exit 0
fi
#
retVal=""
#
usageLine="$(basename "$0")"" [none|bold|underscore|blink|reverse [colorName [bgrColorName]]]"
#
if [ $# -ge 1 ]; then
	retVal="$retVal""\e["
	case "$1" in
		"none") retVal="$retVal""00";;
		"bold") retVal="$retVal""01";;
		"underscore") retVal="$retVal""04";;
		"blink") retVal="$retVal""05";;
		"reverse") retVal="$retVal""07";;
		"reverse") retVal="$retVal""07";;
		"concealed") retVal="$retVal""08";;
		*)
			printUsage.bash "$usageLine"
			exit 13
			;;
	esac
fi
#
if [ $# -ge 2 ]; then
	retVal="$retVal"";"
	if isInteger "$2"; then
		retVal0="$(getColorName $2)"
		retVal0="$(getColorNum "$retVal0")"
		retVal0=$((retVal0+30))
		retVal="$retVal""$retVal0"
	else
		retVal0="$(getColorNum "$2")"
		retVal0=$((retVal0+30))
		retVal="$retVal""$retVal0"
	fi
fi
#
if [ $# -ge 3 ]; then
	retVal="$retVal"";"
	if isInteger "$3"; then
		retVal0="$(getColorName $3)"
		retVal0="$(getColorNum "$retVal0")"
		retVal0=$((retVal0+40))
		retVal="$retVal""$retVal0"
	else
		retVal0="$(getColorNum "$3")"
		retVal0=$((retVal0+40))
		retVal="$retVal""$retVal0"
	fi
fi
#
retVal="$retVal""m"
#
printf "$retVal"
#
# eof
