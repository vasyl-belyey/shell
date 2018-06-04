#! /bin/bash
#
# Init:
optList=("-a" "-s" "-n" "-r" "-v" "-m" "-p" "-i" "-o")
optNames=("all" "kernel name" "network node hostname" "kernel release" "kernel version" "machine hardware name" "processor type or \"unknown\"" "hardware platform or \"unknown\"" "operating system")
optLen=${#optList[*]}
clear; printf "\n\n\n\t\t\tuname:\n"
###printf "optList = %s\n" "${optList[@]}"
###printf "optLen = %d\n" $optLen
#
for((iOpt=0; iOpt < optLen; iOpt++)); do
	optValue="${optList[iOpt]}"
	optName="${optNames[iOpt]}"
	setTextAttributes.bash none cyan
	printf "\t\t\tOption[%d]: '%s': %s\n" $iOpt "$optValue" "$optName"
	setTextAttributes.bash bold green
	uname "$optValue"
	setTextAttributes.bash
done
#uname -a
printf "\n\n\n\t\t\tX-bit platform? (getconf LONG_BIT):\n"
getconf LONG_BIT
#
# eof
