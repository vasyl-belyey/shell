. "$(vbShellDir.bash)""/isMAC.fun"
paPlay() {
	# local filS=($(ls /usr/share/sounds/ubuntu/stereo/phone-outgoing-busy.ogg))
	local i iFile="*" dirSearch=/usr/share/sounds retVal
	while [ ! -z "$1" ]; do iFile="$iFile""$1""*"; shift; done
# echo "iFile='$iFile'"
	# local filS=($(ls /usr/share/sounds/ubuntu/stereo/$iFile.ogg 2>/dev/null))
	local filS=()
	if (retVal=$(isMac 2>/dev/null)); then
		dirSearch=/System/Library/Sounds
		filS=($(find "$dirSearch" -iname "$iFile.aiff" 2>/dev/null))
	else
		dirSearch=/usr/share/sounds
		if ! filS=($(find "$dirSearch" -iname "$iFile.ogg" 2>/dev/null)) || [ -z "$filS" ]; then
			if ! filS=($(find "$dirSearch" -iname "$iFile.oga" 2>/dev/null)) || [ -z "$filS" ]; then
				filS=($(find "$dirSearch" -iname "$iFile.wav" 2>/dev/null))
			fi
		fi
	fi
# echo "filS=(${filS[*]})"
	iFile=-1
	#
	local nFiles=${#filS[*]}
	#
	if [ $nFiles -lt 1 ]; then
		return 13
	else 	if [ $nFiles -eq 1 ]; then
			filS="${filS[0]}"
		else
			# for((iFile = 0; iFile < nFiles; iFile++)); do
			# done
			filS="${filS[0]}"
		fi
	fi
	#
# echo "filS='$filS'"
	if [ -f "$filS" ]; then
		if (retVal=$(isMac 2>/dev/null)); then
			(afplay "$filS" 2>/dev/null)
		else
			(paplay "$filS" 2>/dev/null)
		fi
	else
		return 13
	fi
}
