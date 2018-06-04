#! /bin/bash
#
# Functions:
#
. "doCMD.fun"
. "exists.fun"
. "askYN.fun"
. "askYNsilent.fun"
. "askProceed.fun"
. "printFile.fun"
. "isMac.fun"
. "isInteger.fun"
. "stringContains.fun"
. "indexOf.fun"
. "parseOption.fun"
. "printSeconds.fun"
. "printColored.fun"
. "printColoredOpt.fun"
. "isSudoer.fun"
. "lsofVB.fun"
. "cursorGoTo.fun"
. "paPlay.fun"
. "maxOf.fun"
. "minOf.fun"
. "dirName.fun"
# . "includeAll.fun"; (includeAll 2>/dev/null)
#
timeOfFile() {
	local filMPG="$1"
	local n=${#filMPG} # length
	local n0=$((n - nREST)) # pos0
	if ! isInteger "$n0" || [ $n0 -lt 0 ]; then doCMD "Bad n_0 $n0" 1 0; fi
	local n1=$((nREST - 5)) # length = nREST - length(.mpeg)
	local pc="${filMPG:n0:n1}"
	#
	# n=$(indexOf "$pc" "T")
	# if isInteger "$n" && [ $n -gt 0 ]; then pc[$n]=" "; fi
	pc=${pc/"T"/" "}
	#
	local t0="0"
	if ! t0=$(date --utc --date="$pc" +%s); then
		printColored red "\t\t ERROR computing t0='$t0'\n\n\n\n\n"
		exit 13
	fi
	#
	echo "$t0"
}
#
mergeMPEGfiles() {
	local CMD="cat " CMDremove="rm -v " i filOUT="" filMPG="${filesMPG[iFIRST]}"
	# output file name:
	local n=${#filMPG} # length
	local n0=$((n - 5)) # first part until after HH before .mpeg
	filOUT="${filMPG:0:n0}""00-""$(date --utc --date="@$tLAST" +"%H%M")"".mpeg"
	#
	for((i = iFIRST; i <= iLAST; i++)); do
		filMPG="${filesMPG[i]}"
		CMD="$CMD"" ""\"$filMPG\""
		CMDremove="$CMDremove"" ""\"$filMPG\""
		filesUSED=( ${filesUSED[*]} "$filMPG" )
	done
	CMD="$CMD"" > ""\"$filOUT\""
	#   echo "CMD = '$CMD'"
	doCMD "$CMD" 1 1
	# DEBUG:
	#   doCMD "ls -l \"$filOUT\"" 1 1
	#   doCMD "totem \"$filOUT\"" 1 1
	#   exit 13
	# DEBUG.
	#
	if ! i=$(tty); then
		if [ $lookOutput -ne 0 ]; then doCMD "exeCMD.bash \"totem $filOUT\" 60 \"        Auto-quit\"" 0 1; fi
		if askYNsilent "             Remove used files?"; then
			doCMD "$CMDremove" 1 1
		fi
	else
			doCMD "$CMDremove" 0 1
	fi
}
#
# Init:
clear
printf "\n\n\n"
usageLine="$(basename "$0")"" [options] \n\n \
		options: \n \
	--parent parentDirectoryID \n \
	-N Nhours : number of hours to merge into one file. Default 4; must be > 1. \n \
	-L -> Look every merged output file (in totem). \n \
	-E -> Start from first available hour (NOT an \"even hour\"). \n \
	\n"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if ! pc=$(which gdrive); then
	printUsage.bash "$usageLine" "\t gdrive is not installed.\nTry running:\n\t custom.Ubuntu.bash -P gdrive-linux-x64\nthen re-running:\n\t $(basename "$0") $* \n\n"
	exit 13
fi
#
if lookOutput=$(parseOption "-L" $*); then lookOutput=1; else lookOutput=0; fi
if evenHour=$(parseOption "-E" $*); then evenHour=0; else evenHour=1; fi
#
if ! parentDirectoryID=$(parseOption "--parent" $*); then
	parentDirectoryID="$TGmovieDirID"
fi
if [ -z "$parentDirectoryID" ]; then
	printUsage.bash "$usageLine" "parentDirectoryID must be given.\n Tips: Check the value of 'TGmovieDirID' in your environment."
	exit 13
fi
#
if ! Nhours=$(parseOption "-N" $*); then
	Nhours=4
fi
if ! isInteger "$Nhours" || [ $Nhours -lt 2 ]; then
	printUsage.bash "$usageLine" "argument -N (Nhours) must be an integer > 1,  not '$Nhours'."
	exit 13
fi
#
#
# Main:
#
#
#
	pc="0"
if isInteger "$pc" && [ $pc -gt 0 ]; then
	printColored green "\n\n\n\t\t\t\t\t\t\t Just for fun/future use:\n"
	# template:# if ! [ -z "$parentDirectoryID" ]; then CMD="$CMD"" --parent $parentDirectoryID "; fi
	CMD="gdrive list --name-width 0 --max 0 --no-header --order name_natural --query \"name contains '2018-'"
	if ! [ -z "$parentDirectoryID" ]; then CMD="$CMD"" and '$parentDirectoryID' in parents"; fi
	CMD=$CMD\"
	doCMD "$CMD" 1 1
	printColored yellow "\t\t\t\t\t\t\t You have " green "$pc" yellow " seconds to enjoy :-)\n\n\n"; sleep $pc; clear
fi
# end.for_fun.
#
#
#
# main:
dirPWD=$(pwd)/
dirTMP="$HOME/Videos/" # $dirPWD/TMP/
dirMPEG="$dirTMP""TG/"
if exists "-d" "$dirMPEG"; then
	if ! i=$(tty) || askYNsilent "             Target directory '$dirMPEG' exists.  Delete it?"; then
		doCMD "rm -vRf \"$dirMPEG\"" 1 1
	fi
fi
if ! exists "-d" "$dirMPEG"; then
	# CMD="gdrive sync download --keep-remote --delete-extraneous --dry-run --no-progress $parentDirectoryID $dirTMP"
	# CMD="gdrive download --recursive --path $dirTMP $parentDirectoryID" # abandon --recursive
	CMD="gdrive download --recursive --path $dirTMP $parentDirectoryID" # TODO: think about --delete option !!!
	doCMD "$CMD" 1 1
fi
doCMD "cd \"$dirMPEG\"" 1 1
doCMD "ls -l *.mpeg" 1 1
#
# main work:
aMask="*.????-??-??T??.mpeg"; nREST=$(( ${#aMask} - 2 )) # for future use as an argument (--mask)
filesMPG=( $(ls $aMask) )
nF=${#filesMPG[*]}
tFIRST=0; iFIRST=-1; iLAST=$(( iFIRST - 1 ))
for((iF=0; iF<nF; iF++)); do
	filMPG="${filesMPG[iF]}"
	printColored white "filesMPG[$(printf "%03d" $iF)] = '" yellow "$filMPG" white "'"
	#
	t0=$(timeOfFile "$filMPG")
	printColored blue "\t t0='" green "$(date --utc --date=@$t0)" blue "'"
	#
	printColored white "\n"
	#
	iLAST=$iF # ; tLAST=$(( t0 + Nhours*3600 - 1 ))
	if (! [ $evenHour -ne 0 ] || [ $(( t0 % (Nhours*3600) )) -eq 0 ]) && ([ $iFIRST -lt 0 ]); then
		iFIRST=$iF
		tFIRST=$t0
		tLAST=$(( t0 + Nhours*3600 - 1 ))
		printColored yellow "\t\t iFIRST = '$iFIRST',  tFIRST = '$(date --utc --date=@$tFIRST)' ,  tLAST = '$(date --utc --date=@$tLAST)' ...\n"
	else
		if [ $iFIRST -ge 0 ] && [ $tLAST -le $t0 ]; then
			iLAST=$(( iF - 1 ))
			if [ $iLAST -lt $iFIRST ]; then iLAST=$iFIRST; fi
			printColored yellow "\t\t\t iLAST = '$iLAST',  tFIRST = '$(date --utc --date=@$tFIRST)' ,  tLAST = '$(date --utc --date=@$tLAST)' ...\n"
			mergeMPEGfiles
			tFIRST=0; iFIRST=-1
			if [ $iF -ge 0 ]; then ((iF--)); fi
		fi
	fi
	#
done
# last portion:?
if (! [ $evenHour -ne 0 ] || [ $((iLAST-iFIRST+1)) -eq $Nhours ]) && [ $iFIRST -ge 0 ] && [ $iFIRST -lt $nF ] && [ $iLAST -gt $iFIRST ]; then
	mergeMPEGfiles
	tFIRST=0; iFIRST=-1
fi
printf "\n\n\n"
ls $aMask
echo ""
aMaskH="*.????-??-??T????-????.mpeg"
if ls -l $aMaskH; then
	if i=$(tty) && echo "" && askYNsilent "       Proceed? (DEBUG)"; then echo "Okay"; echo; fi
	doCMD "cd \"$dirPWD\"" 1 1
	#
	# inside parentDirectoryID:  CMD="gdrive upload --parent $parentDirectoryID --recursive $dirMPEG"
	# CMD="gdrive upload --recursive $dirMPEG"
	#
	# download one by one file:
	filesDL=( $(ls $dirMPEG$aMaskH) )
	nDL=${#filesDL[*]}
	for((iDL = 0; iDL < nDL; iDL++)); do
		filDL=${filesDL[iDL]}
		if exists -f "$filDL"; then
			CMD="gdrive upload --parent \"$parentDirectoryID\" --share --delete \"$filDL\""
			doCMD "$CMD" 1 1
		fi
	done
	#
	# delete used remote files:
	#   filesDL=filesUSED
	nDL=${#filesUSED[*]}
	for((iDL = 0; iDL < nDL; iDL++)); do
		filDL=${filesUSED[iDL]}
		if askYNsilent "             Delete the remote file '$filDL'?"; then
			# getFileID:
			CMD="filID=( \$(gdrive list --no-header --name-width 0 --query \"name = '$filDL'\") )"
			# echo "CMD = '$CMD'"
			doCMD "$CMD" 1 1
			# echo "filID = '${filID[*]}'"
			# echo "NfilID = '${#filID[*]}'"
			if [ ${#filID[*]} -ne 7 ]; then
				printColored red "\n\n\n\t\t\t Ambiguous filID='${filID[*]}'\n\n\n"
				exit 13
			fi
			filID=${filID[0]}
			# echo "filID = '$filID'"
			#
			CMD="gdrive delete $filID"
			doCMD "$CMD" 1 1
		fi
	done
	#
	# delete work dir:
	if exists -d "$dirMPEG"; then doCMD "rm -vRf \"$dirMPEG\"" 1 1; fi # instead of "--delete" option
fi
#
# main work.
#
# END
printf "\n\n\n"
# eof
