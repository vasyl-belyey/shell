#! /bin/bash
#
# F:
#
# Init:
usageLine="$(basename "$0")"" nOF N"
lineLength=60
lineLength=133
lineLength=157
lineLength=100
#
# Checks:
nOF="$1"
if [ "${nOF:0:1}" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
if [ $# -lt 2 ]; then
	printUsage.bash "$usageLine" "Too few arguments."
	exit 13
fi
if ! isInteger.bash "$nOF"; then
	printUsage.bash "$usageLine" "Argument nOF must be integer (not '""$nOF""')."
	exit 13
fi
N="$2"
if ! isInteger.bash "$N"; then
	printUsage.bash "$usageLine" "Argument N must be integer (not '""$N""')."
	exit 13
fi
#
# Main:
nP=$((nOF*lineLength/N))
nM=$((lineLength - nP))
###
setTextAttributes.bash bold green
for((i=0; i<nP; i++)); do
	printf "+"
done
###
setTextAttributes.bash bold red
for((i=0; i<nM; i++)); do
	printf "-"
done
###
perCent=$((nOF*100/N))
aColor=red
if [ $perCent -ge 33 ]; then
	if [ $perCent -ge 67 ]; then
		aColor=green
	else
		aColor=yellow
	fi
fi
setTextAttributes.bash bold "$aColor"
###printf "%d / %d" $nOF $N
printf "  => %3d%%   " $perCent
#
# END:
setTextAttributes.bash
printf "\n"
#
# eof
