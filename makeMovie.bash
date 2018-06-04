#! /bin/bash
#
# Functions:
#
. "$(vbShellDir.bash)""/doCMD.fun"
. "$(vbShellDir.bash)""/exists.fun"
. "$(vbShellDir.bash)""/askYN.fun"
. "$(vbShellDir.bash)""/askYNsilent.fun"
. "$(vbShellDir.bash)""/askProceed.fun"
. "$(vbShellDir.bash)""/printFile.fun"
. "$(vbShellDir.bash)""/isMac.fun"
. "$(vbShellDir.bash)""/isInteger.fun"
. "$(vbShellDir.bash)""/stringContains.fun"
. "$(vbShellDir.bash)""/indexOf.fun"
. "$(vbShellDir.bash)""/parseOption.fun"
. "$(vbShellDir.bash)""/printSeconds.fun"
. "$(vbShellDir.bash)""/printColored.fun"
. "$(vbShellDir.bash)""/isSudoer.fun"
. "$(vbShellDir.bash)""/lsofVB.fun"
. "$(vbShellDir.bash)""/cursorGoTo.fun"
#
isTTY() {
	local pc=$(tty)
	return $?
}
#
createParamFile() {
	filePars=$dirPPM/paramfile.mmk
	if exists -f "$filePars"; then
		if [ $forceSilent -eq 0 ] && (isTTY) && (! askYNsilent "\n\n\nParameter file='""$filePars""' exists.  Overwrite?"); then
			return 13
		fi
	fi
	#
	local iMin=1;  local iMax=-1
	local lsIN
	lsIN=( $(ls $dirPPM/img*.ppm) ) # 2>/dev/null
	iMax=${#lsIN[*]}
	#
	if [ $iMax -lt 1 ]; then
		printColored red "\n\t\t\tBad number of input files: iMin=""$iMin"",  iMax=""$iMax""\n\n"
		return 13
	fi
	#
	printf "%s\n" "PATTERN I" > "$filePars"
	printf "%s\n" "PIXEL HALF" >> "$filePars"
	printf "%s\n" "IQSCALE 10" >> "$filePars"
	printf "%s\n" "PQSCALE 10" >> "$filePars"
	printf "%s\n" "BQSCALE 10" >> "$filePars"
	printf "%s\n" "RANGE 10" >> "$filePars"
	printf "%s\n" "PSEARCH_ALG LOGARITHMIC" >> "$filePars"
	printf "%s\n" "BSEARCH_ALG SIMPLE" >> "$filePars"
	printf "%s\n" "OUTPUT ""$fileOut" >> "$filePars"
	printf "%s\n" "GOP_SIZE 5" >> "$filePars"
	printf "%s\n" "SLICES_PER_FRAME 1" >> "$filePars"
	printf "%s\n" "BASE_FILE_FORMAT PPM" >> "$filePars"
	printf "%s\n" "INPUT_CONVERT *" >> "$filePars"
	printf "%s\n" "INPUT_DIR ""$dirPPM" >> "$filePars"
	printf "%s\n" "INPUT" >> "$filePars"
	printf "%s [%06d-%06d]\n" "img*.ppm" $iMin $iMax >> "$filePars"
	printf "%s\n" "END_INPUT" >> "$filePars"
	printf "%s\n" "REFERENCE_FRAME DECODED" >> "$filePars"
	#
	printFile "$filePars"
	#
	return 0
}
#
# Init:
clear
usageLine="$(basename "$0")"" [-s(ilent)] [-d dirPPM=./] [-o outputFileName=movie.mpeg] [-f=forceRemove]"\
"\n\n\tCombines ppm frame files into mpeg file."
#
if ! dirPPM=$(parseOption -d $*); then dirPPM=$(pwd); fi
if ! fileOut=$(parseOption -o $*); then fileOut=$dirPPM/movie.mpeg; fi
if [ ! "${fileOut:$((${#fileOut}-5)):5}" = ".mpeg" ]; then fileOut=$fileOut.mpeg; fi
if parseOption -f $*; then forceRemove=1; else forceRemove=0; fi
if parseOption -s $*; then forceSilent=1; else forceSilent=0; fi
#
printColored yellow "\n\n\n\tDoing '""$(basename $0) -d $dirPPM -o $fileOut""'...\n\n"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if ! exists -d "$dirPPM"; then
	printUsage.bash "$usageLine" "dirPPM='""$dirPPM""' does not exist."
	exit 13
fi
#
cmdName="ppmtompeg"
if ! (which $cmdName > /dev/null); then
	printUsage.bash "$usageLine" "Command '""$cmdName""' not installed."
	exit 13
fi
#
#
# Main:
doCMD createParamFile 1 -1
doCMD "$cmdName $filePars" 1 -1
#
if [ $forceSilent -eq 0 ] && (isTTY) && (exists -f "$fileOut") && (which totem) && (askYNsilent "\n\tWatch '$fileOut'?"); then (totem "$fileOut"); fi
#
if [ $forceRemove -ne 0 ] || (isTTY && askYNsilent "\n\tRemove used img*.ppm files?"); then
	doCMD "rm -v $dirPPM/img*.ppm" 1 -1
	doCMD "rm -v $filePars" 1 -1
fi
#
# END
printColored green "\n\n\n\tDone '""$(basename $0) -d $dirPPM -o $fileOut""'.\n\n\n\n"
# eof
