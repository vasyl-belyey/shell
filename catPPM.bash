#! /bin/bash
#
# Functions:
#
isPPM() {
	retVal=1; cType="UNKNOWN"; cNX=-1; cNY=-1
	if [ -f "$1" ]; then
		aLine="-"; nLines=0
		while [ "$aLine" != "" ]; do
			read aLine
			if [ "$aLine" = "" ]; then echo "BREAK"; break; fi
		#	printf "aLine[%d] = '%s'\n" $nLines "$aLine"
			case $nLines in
				0) cType="$aLine";;
				1) if [ "${aLine:0:1}" != "#" ]; then printf "\t\t\tUnexpected aLine[1] = '%s'.\n" "$aLine"; break; fi;;
				2) cN=("$aLine")
		#			printf "\t\t\tcN = '%s'\n" "$cN"
					i=0
					for n in $cN; do
		#				printf "\t\t\t\t\t\t\tn[%d] = %d\n" $i $n
						case $i in
							0) cNX=$n;;
							1) cNY=$n;;
							*) printf "\n\n\n\t\t\tInvalid number of pixels: i = %d > 1\n\n\n\n" $i; exit 13;;
						esac
						i=$((i+1))
					done
					retVal=0; break
				;;
				*) break;;
			esac
			nLines=$((nLines+1))
		done < "$1"
	fi
	printf "\t\t\t\tReturning %d with cType = '%s', cNX = %d, and cNY = %d.  File '%s'.\n" $retVal "$cType" $cNX $cNY "$1"
	#exit 13
	return $retVal
}
#
appendFile() {
	aLine="-"; nLines=0
		while [ "$aLine" != "" ]; do
			read aLine
			if [ "$aLine" = "" ]; then echo "BREAK"; break; fi
			if [ $2 -eq 0 ]; then
				if [ $nLines -eq 2 ]; then
					echo "$nX $nY" >> "$outFile"
				else
					echo "$aLine" >> "$outFile"
				fi
			else
				if [ $nLines -gt 2 ]; then
					echo "$aLine" >> "$outFile"
				fi
			fi
			nLines=$((nLines+1))
		done < "$1"
}
#
# Init:
usageLine="$(basename "$0")"" -h|-v|- file1 file2 [file3 ...] [outputFile]"
arg1="$1"
isVertical=1
# Check:
case "$arg1" in
	"-")
		printUsage.bash "$usageLine"
		exit 13
	;;
	"-h")
		isVertical=0
		printUsage.bash "$usageLine" "Unimplemented option -h."
		exit 13
	;;
	"-v")
		isVertical=1
	;;
	*)
		printUsage.bash "$usageLine" "Invalid arg1: '""$arg1""'."
		exit 13
	;;
esac
# Check:
if [ $# -lt 3 ]; then
		printUsage.bash "$usageLine" "Too few arguments."
		exit 13
fi
#
# Main:
clear
#
inFiles=""
nInFiles=0
shift
while [ "$1" != "" ]; do
	outFile="$1"
	#if [ -f "$outFile" ]; then
	if isPPM "$1"; then
		nX=$cNX; nY=$cNY
		inFiles[$nInFiles]="$1"
		nInFiles=$((nInFiles+1))
		#echo "Input file '""$outFile""' added."
		outFile=""
	else
		#echo "Output file '""$outFile""'."
		break
	fi
	shift
done
nInFiles=${#inFiles[*]}
if [ $nInFiles -lt 2 ]; then
		printUsage.bash "$usageLine" "Too few input files (""$nInFiles"")."
		exit 13
fi
printf "\n\n\n\t\t\tCatenating %d input files...\n" $nInFiles
#
if [ "$outFile" = "" ]; then
	read -p "Enter output file name: " outFile
fi
#
if [ $isVertical -ne 0 ]; then
	printf "\tnY = %d   nInFiles = %d " $nY $nInFiles
	nY=$((nY*nInFiles))
	printf "\tnY = %d\n" $nY
else
	printf "\tnX = %d   nInFiles = %d " $nX $nInFiles
	nX=$((nX*nInFiles))
	printf "\tnX = %d\n" $nX
fi
#exit 13
for ((i=0; i<nInFiles; i++)); do
	inFile="${inFiles[i]}"
	printf "Reading file # %d: '%s'...\n" $i "$inFile"
	appendFile "$inFile" $i
done
#
printf "\n\n\n\t\t\tSUCCESS.  Output written to '%s'.  Bye.\n\n\n\n" "$outFile"
# eof
