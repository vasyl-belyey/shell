cursorGoTo() {
	local aLine="$1"
	local aColumn="$2"
	if [ -z "$aLine" ]; then aLine=0; fi
	if [ -z "$aColumn" ]; then aColumn=0; fi
	# printf "\033[""$aLine"";""$aColumn""H"
	printf "\033[%d;%dH" $aLine $aColumn
}
