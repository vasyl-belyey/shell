printColoredOpt() {
	# usageLine=printColoredOpt [-A+none|bold|underscore|blink|reverse|concealed] [-B+bgrColor] [-C+color] format args
	local args=() arg
	#
	if arg=$(parseOption "-A" $*); then
		shift
		case "$arg" in
			"bold") args[0]="$arg";;
			"underscore") args[0]="$arg";;
			"blink") args[0]="$arg";;
			"reverse") args[0]="$arg";;
			"concealed") args[0]="$arg";;
			*) args[0]="none";;
		esac
	else
		args[0]="none"
	fi
	#
	if arg=$(parseOption "-B" $*); then
		shift
		args[2]="$arg"
	else
		# args[2]="black"
		args[2]=""
	fi
	#
	if arg=$(parseOption "-C" $*); then
		shift
		args[1]="$arg"
	else
		args[1]="white"
	fi
	setTextAttributes.bash ${args[*]}
	arg="$1"; shift
	printf "$arg" $*
	setTextAttributes.bash
}
