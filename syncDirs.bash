#! /bin/bash
#
# Functions:
. removeSlash.fun
. askYN.fun
. askYNsilent.fun
. isInteger.fun
. indexOf.fun
#
getLastIP() {
	local retVal=$(zFile.bash read "$filLastIP")
	if ! isInteger.bash "$retVal"; then
		retVal=29
	fi
	#
	echo $retVal
}
#
setLastIP() {
	local retVal=$1
	if ! isInteger.bash "$retVal"; then
		retVal=29
	fi
	retVal=$(zFile.bash write "$filLastIP" "$retVal")
}
#
# Init:
filLastIP=$(vbShellDir.bash)"/""$(basename "$0")"".lastIP.txt"
clear
usageLine="$(basename "$0")"" srcDir trgDir"
#
if [ $# -eq 1 ] && [ ! -d "$1" ]; then
	trgIP="$1"
	shift
else
	trgIP=""
fi
#
iN=0
srcDF[$iN]="$1"; iN=$((iN+1))
srcDF[$iN]=""; iN=$((iN+1))
iN=0
trgDF[$iN]="$2"; iN=$((iN+1))
trgDF[$iN]=""; iN=$((iN+1))
#
if [ -z "${srcDF[0]}" ]; then
	srcDF[0]="$(pwd)"
fi
if [ -d "${srcDF[0]}" ]; then
	srcDF[0]="$(dirName.bash "${srcDF[0]}")"
fi
#
if [ -z "${trgDF[0]}" ]; then
	srcDir=${srcDF[0]}
	if [[ "$srcDir" =~ ":" ]]; then
		srcDir="${srcDir/*:/}"
		srcDir="${srcDir/'~'/"\$HOME"}"
		trgDF[0]="$srcDir"
	else
		if [ ! -z "$trgIP" ]; then
			trgDF[0]="$trgIP"":""$srcDir"
			tmp=${srcDir/$HOME/:}
			if [ "${tmp:1:1}" = "/" ]; then
				tmp="${tmp:0:1}""${tmp:2}"
			fi
			tmp="$trgIP""$tmp"
			trgDF[0]="$tmp"
### echo ${trgDF[0]}; exit 13
		else
			nHOME=${#HOME}
			if [ "${srcDir:0:nHOME}" = "$HOME" ]; then
				# srcDir="${srcDir/"$HOME"/~}"
				srcDir="${srcDir/"$HOME"/"\$HOME"}"
			fi
			# nIP=29
			nIP=$(getLastIP)
			answer=""
			read -p "  Enter  nIP = 10.0.0.[""$nIP""]: " answer
			if [ "$answer" = "" ]; then
				answer="$nIP"
			else
				setLastIP $answer
			fi
			nIP="10.0.0.""$answer"
			#							printColored.bash red "\n\n\n\t\t\t\t\t\t\t nIP = '""$nIP""'\n\n\n"; exit 13
			trgDF[0]="$nIP"":""$srcDir"
		fi
	fi
fi
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
#
# Main:
#
srcDir=${srcDF[0]}
if [ ! -d "$srcDir" ]; then
	printUsage.bash "$usageLine" "Source dir '""$srcDir""' does not exist."
	if askYN.bash "   A remote dir?"; then
		printColored.bash green "OK, accept...\n\n\n"
	else
		exit 13
	fi
else
	srcDir="$(dirName.bash "$srcDir")"
	#
	# if askYN.bash "             Clean '""$srcDir""' before copying?" "yn" 1; then
	if askYN.bash "             Clean '""VBlibs/Apps/""' before copying?" "yn" 1; then
		# cleanVB.bash "$srcDir"
		cleanApps.bash
	fi
	#
fi
printColored.bash green "\n\t\t\tSource dir '""$srcDir""'\n"
#
trgDir=${trgDF[0]}
if [ ! -d "$trgDir" ]; then
	printUsage.bash "$usageLine" "Target dir '""$trgDir""' does not exist."
	if askYN.bash "   A remote dir?"; then
		printColored.bash green "OK, accept...\n\n\n"
	else
		exit 13
	fi
else
	trgDir="$(dirName.bash "$trgDir")"
	#
	if askYN.bash "             Clean '""$trgDir""' before copying?" "yn" 1; then
		cleanVB.bash "$trgDir"
	fi
	#
	# 20150516:VB:
	# backupCopy="$(dirName.bash)""/""$(basename "$trgDir")"".BACKUP.""$(date +%Y%m%d)"
	backupCopy="$trgDir"
	nE=${#backupCopy}; nE=$((nE - 1))
	if [ "${backupCopy:$nE:1}" = "/" ]; then
		backupCopy=${backupCopy:0:$nE}
	fi
	backupCopy="$backupCopy"".BACKUP.""$(date +%Y%m%d)"
	if askYN.bash "   Create backup copy '""$backupCopy""' ?"; then
		CMD="cp -pRv ""$trgDir"" ""$backupCopy"
		# CMD="lsz -la ""$trgDir"
		printColored.bash green "\t\t\tDoing '""$CMD""'...\n"
		if oneLineCMD.bash $CMD; then
			printColored.bash green "\t\t\tDone '""$CMD""' :-)\n\n\n"
			Beep.sh
		else
			printColored.bash red "\t\t\tERROR in '""$CMD""' :-(\n\n\n"
			Beep.sh 3
		fi
	fi
	#
fi
printColored.bash red "\n\t\t\tTarget dir '""$trgDir""'\n"
#
answer="$(isMAC.bash)"; retCode=$?
############# if [ $retCode -eq 0 ]; then
echo $trgDir
trgDir="$(removeSlash "$trgDir")"
srcDir="$(removeSlash "$srcDir")"
	# CMD="rsync -avrupt --exclude '.classpath .project .metadata' --executability --progress ""$srcDir""/"" ""$trgDir""/"
	CMD="rsync -avrupt --executability --progress ""$srcDir""/"" ""$trgDir""/"
############# else
############# 	printUsage.bash "$usageLine" "Unimplemented for non-MacOS :-("
############# 	exit 13
############# fi
#
# ls -l "$srcDir"; ls -l "$trgDir"
for((iR = 0; iR < 2; iR++)); do
#######################################################################################################################
	case "$iR" in
		0)
			if [ $(indexOf "$trgDir" "gs://") -eq 0 ]; then
				# use gsutil:
				CMD="gsutil -m rsync -rpe ""$srcDir""/"" ""$trgDir""/"
			else
				CMD="rsync -avrupt --executability --progress ""$srcDir""/"" ""$trgDir""/"
			fi
		;;
		1)
			if askYNsilent "\t\t\tDo backward copying?" "yn" 1; then
				CMD="rsync -avrupt --executability --progress ""$trgDir""/"" ""$srcDir""/"
			else
				break
			fi
		;;
	esac
#
printColored.bash red "\n\t\t\tCMD: '""$CMD""'\n\n\n"
if askYN.bash "          Confirm?"; then
	t0="$(date +%s)"
	# $CMD
	if askYN.bash "             Short output format?" "yn" 1; then
		oneLineCMD.bash $CMD
	else
		setTextAttributes.bash bold green
		$CMD
		setTextAttributes.bash
	fi
	retCode=$?
	# ls -l "$srcDir"; ls -l "$trgDir"
	t1="$(date +%s)"
	t1=$((t1 - t0))
	printColored.bash green "\t\t\t\t\t\t\tIt took ""$(printSeconds.bash $t1)""\n"
else
	retCode=13
fi
#
if [ $retCode -eq 0 ]; then
	printColored.bash green "\n\n\n\t\t\tSUCCESS\n\n\n"
	Beep.sh 1
	#
	if [ -d "$trgDir" ]; then
		if askYN.bash "             Clean '""$trgDir""' after copying?" "yn" 1; then
			cleanVB.bash "$trgDir"
		fi
	fi
	#
else
	printColored.bash red "\n\n\n\t\t\tERROR ""$retCode""\n\n\n"
	Beep.sh 3
fi
#######################################################################################################################
done
#
# END
# eof
