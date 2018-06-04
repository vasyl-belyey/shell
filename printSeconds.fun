#
printSeconds() {
	local nS=$1
	local nDays=$(( nS / (3600*24) ))
	nS=$(( nS % (3600*24) ))
	local nH=$(( nS / 3600))
	nS=$(( nS % 3600 ))
	local nM=$(( nS / 60 ))
	nS=$(( nS % 60 ))
	#printf "\r%s%02d:%02d:%02d" "$header" $nH $nM $nS
	if [ $nDays -eq 0 ]; then
		printf "%02d:%02d:%02d" $nH $nM $nS
	else
		printf "%dd+%02d:%02d:%02d" $nDays $nH $nM $nS
	fi
	###
	if [ "$footer" != "" ]; then printf "\n"; fi
	#
	if [ "$2" != "" ]; then
		nS=$2
		let nH=$nS/3600
		let z=$nH*3600
		let nS=$nS-$z
		let nM=$nS/60
		let z=$nM*60
		let nS=$nS-$z
		printf " / %02d:%02d:%02d" $nH $nM $nS
	fi
	#printf "%13s" " "
}
#
# eof
