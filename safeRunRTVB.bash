#! /bin/bash
####! /bin/sh
#
# functions
#
Usage() {
	printf "\n\n\n""$usage""\n\n\n"
	exit 0
}
#
getFileName() {
	s="$1"
	while [[ "$s" =~ "/" ]]
	do
		###s=${s:1:$(#s)}
		s=${s:1:${#s}}
		### sh: ###s=`expr substr "$s" 2 ${#s}`
	done
	echo "$s"
}
#
# Main
clear
#
# initialize
usageLine="$(basename "$0")"" cmdFileName [RTVBpath] [RTVBoutDir]"
usage="Usage: ""$0"" cmdFileName [RTVBpath] [RTVBoutDir]"
jarRTVB="RTVB.jar"
#
# check
if [ $# -lt 1 ]; then
	#Usage; 
	printUsage.bash "$usageLine" "Too few arguments"
	exit 13
fi
# 	command file
pcCmdFile="$1"
cmdFile="$(VaBe.sh "absolutePath" "$pcCmdFile")"
#printf "\n\n\n\tcmdFile='""$cmdFile""' ...\n\n\n"
if [ ! -f "$cmdFile" ]; then
	#printf "\n\n\n\tCommand file '""$cmdFile""' does not exist."
	#Usage
	if [ ${pcCmdFile:0:1} = "-" ]; then
		printUsage.bash "$usageLine"
		exit 13
	fi
	printUsage.bash "$usageLine" "Command file '""$cmdFile""' does not exist."
	exit 13
fi
printf "\n\n\n\tcmdFile='""$cmdFile""' okay.\n\n\n"
# 	RTVB file
pcRTVB="$2"
if [ "$pcRTVB" = "" ]; then pcRTVB="$HOME""/""$jarRTVB"; fi
if [ -d "$pcRTVB" ]; then pcRTVB="$pcRTVB""/""$jarRTVB"; fi
if [ ! -f "$pcRTVB" ]; then printf "\n\n\n\tRTVB executable JAR file '""$pcRTVB""' does not exist."; Usage; fi
printf "\n\n\n\tpcRTVB='""$pcRTVB""' okay.\n\n\n"
# 	output root directory
outRootDir=$(VaBe.sh "absolutePath" "$3")
if [ "$outRootDir" = "" ]; then outRootDir=$(pwd)"/"; fi
if [ ! -d "$outRootDir" ]; then printf "\n\n\n\tRTVB output directory '""$outRootDir""' does not exist."; Usage; fi
printf "\n\n\n\toutRootDir='""$outRootDir""' okay.\n\n\n"
# 	output work directory
###outDir="$outRootDir""/"$(getFileName "$pcCmdFile")"."$(date -u "+%Y-%m-%dT*")
outDir="$outRootDir""/""*."$(date -u "+%Y-%m-%dT*")
printf "\n\n\n\toutDir='""$outDir""'.\n\n\n"
#
# EDIT
ask="Edit_""$cmdFile""_?"
yn=$(VaBe.sh "askYN" "$ask")
if [ "$yn" = "y" ]
then
	CMD="vi ""$cmdFile"
	printf "\n\n\n\tCMD='""$CMD""'.\n\n\n"
	$CMD
fi
#
# RUN
maxHeap="512M"
maxHeap="1G"
#maxHeap="16G"
#CMD="java -jar -Xmx""$maxHeap"" ""$pcRTVB"" -C ""$cmdFile"" -O ""$outRootDir"" -v"
CMD="java -jar -Xmx""$maxHeap"" ""$pcRTVB"" -C ""$cmdFile"" -O ""$outRootDir"" ""$4"" ""$5"" ""$6"" ""$7"" ""$8"" ""$9"
printf "\n\n\n\tCMD='""$CMD""'.\n\n\n"
$CMD
#
# REMOVE
CMD="rm -Rv ""$outDir"
ask="Remove_output_directorIES_""$outDir"
printf "\n\n\n\task='""$ask""'.\n\n\n"
yn=$(VaBe.sh "askYN" "$ask")
if [ "$yn" = "y" ]
then
	df -h .
	printf "\n\n\n\tREMOVING ""$outDir"
	printf "\n\n\n\tCMD='""$CMD""'.\n\n\n"
	$CMD
	df -h .
fi
#
# eof
