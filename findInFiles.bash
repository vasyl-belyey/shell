#! /bin/bash
#
# Functions:
#
. "$HOME/VBlibs/Langs/shell""/doCMD.fun"
. "$HOME/VBlibs/Langs/shell""/exists.fun"
. "$HOME/VBlibs/Langs/shell""/askYN.fun"
#
findFiles() {
	sudo find "$1" -iname "$2" 2>/dev/null | ( while IFS= read -r aFile ; do
		nF=$((nF + 1))
		aOut="\t\t\t\t\t\tExamining file '""$aFile""'...\n"
		printColored.bash yellow "$aOut"
		printf "$aOut" >> "$oFile"
		#
		nLine=0
		while IFS='' read -r aLine || [[ -n $aLine ]]; do
			nLine=$((nLine + 1))
			# if [[ "$aLine" =~ .*My.* ]]; then
			if [[ "$aLine" =~ "$aText" ]]; then
				nM=$((nM + 1))
				aOut="$nLine""\t'""$aLine""'...\n"
				printColored.bash magenta "$aOut"
				printf "$aOut" >> "$oFile"
			fi
		done < "$aFile"
		#
	done
	#
	t1="$(date "+%s")"; t1=$((t1-t0))
	aOut="$(printSeconds.bash $t1)"
	aOut="$(basename "$0")"" search for '""$aText""' in files '""$2""' from '""$1""': ""$nM"" matches found in ""$nF"" files for ""$aOut""\n"
	printColored.bash green "$aOut"
	printf "$aOut" >> "$oFile"
	#
	if [ $t1 -ge 13 ]; then
		Beep.sh 1 "Search for ""$aText"" finished."
	fi
	#
	)
}
#
# Init:
usageLine="$(basename "$0")"" path fileName text"
aText="$3"
oFile="soek.if.txt"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
if [ "$#" -lt 3 ]; then
	printUsage.bash "$usageLine" "Too few arguments given."
	exit 13
fi
#
if ! exists -d "$1" -s; then
	printUsage.bash "$usageLine" "path '""$1""' does not exist."
	exit 13
fi
if [ "$aText" = "" ]; then
	printUsage.bash "$usageLine" "text '""$aText""' not given."
	exit 13
fi
#
# Main:
#
t0="$(date "+%s")"
aOut="$(basename "$0")"" search for '""$aText""' in files '""$2""' from '""$1""' started by ""$USER"" on ""$(date "+%Y%m%d @ %H:%M:%S")""...\n"
printColored.bash green "$aOut"
printf "$aOut" > "$oFile"
nM=0; nF=0
findFiles "$1" "$2"
#
#
aOut="\t\t\tSee results in '""$oFile""' file.\n\n\n"
printColored.bash green "$aOut"
doCMD "less ""$oFile"
# END
# eof
