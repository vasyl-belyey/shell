# IMPORT: . printColored.fun; . parseOption.fun; . plotLineVB.fun; . ./indexOf.fun;
# USAGE: plotLineVB [-I MIN=0] [-A MAX=nCOLS] [-y VALUE=middle] [-g boolShowGrid] [-v boolShowValue]
# NB: OPTIONS MUST BE IN THE SHOWN ORDER!  SPACE BETWEEN OPTNAME AND OPTVALUE IS MANDATORY!
plotLineVB() {
	local yI nY=$(tput cols) yA y i N
	if ! yI="$(parseOption "-I" $*)"; then
		yI=0
	else
		shift 2
	fi
	if ! yA="$(parseOption "-A" $*)"; then
		yA=$nY
	else
		shift 2
	fi
	if ! y="$(parseOption "-y" $*)"; then
		y=$(( (yI + yA) / 2 ))
	else
		shift 2
	fi
	#
	y=$(( (y-yI)*(nY)/(yA-yI) ))
	for((i = 0; i < nY; i++)); do
		if [ $i -lt $y ]; then
			printColored red "+"
		else
			if [ $i -gt $y ]; then
				printColored yellow "-"
			else
				printColored green "|"
			fi
		fi
	done
	printf "\n"
}
