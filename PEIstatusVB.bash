#! /bin/bash
#
# F:
#
# Init:
usageLine="$(basename "$0")"" [nSecTimeOut=13(default), manual stop if 0 or negative]"
#
jarFiNa="$(dirname "$0")"
# jarFiNa="$jarFiNa""/../../Apps"
jarFiNa="$jarFiNa""/../../Apps/PEIstatusVB"
jarFiNa="$(dirName.bash "$jarFiNa")""/"
jarFiNa="$jarFiNa""PEIstatusVB.jar"
printColored.bash green "\n\n\n\t\t\tjarFiNa = '%s'\n\n\n\n" "$jarFiNa"
CMD="java -jar ""$jarFiNa" # " &"
###CMD="exeCMD.bash \"""$CMD""\" 113 PEIstatusVB.bash"
printf "\n\n\n\tCMD = '%s'\n\n\n\n" "$CMD"
#
timeOut=13
if [ "$1" != "" ]; then
	if isInteger.bash $1; then
			timeOut=$1
		else
			if [ "$1" = "-" ]; then
				printUsage.bash "$usageLine"
				exit 13
			else
				printUsage.bash "$usageLine" "Bad parameter '""$1""'."
				exit 13
			fi
		fi
fi
#
# main:
#
###$CMD
if [ $timeOut -gt 0 ]; then
	exeCMD.bash "$CMD" $timeOut "$(basename "$0")"
else
	exeCMD.bash "$CMD"
fi
#
echo
# end
#
# eof
