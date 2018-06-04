#! /bin/bash
#
# Functions:
Usage() {
	# clear
	printf "\n\n\n\n\n\n\n"
	if [ "$1" != "" ]; then setTexAttributes.bash bold red; printf "\tERROR: %s" "$1"; setTextAttributes.bash; printf "\n"; fi
	setTextAttributes.bash bold green; printf "\t\tUsage:"
	setTextAttributes.bash; printf "\n%s [text [errMessage]]\n" "$(basename "$0")"
	printf "\n\n\n\n"
	exit 13
}
#
#
if [ "$1" != "" ]; then arg1="$1"; if [ ${arg1:0:1} = "-" ]; then Usage; fi; fi
#
# clear
printf "\n\n\n\n\n\n\n"
# VB:20150527:
if [ "$2" != "" ]; then
	printColored.bash red "\tERROR: ""$2""\n"
fi
printColored.bash green "\t\t\tUsage:\n"
printColored.bash white "$1""\n"
# VB:20150527.
printf "\n\n\n\n"
# if [ "$2" != "" ]; then setTextAttributes.bash bold red; printf "\tERROR: %s" "$2"; setTextAttributes.bash; printf "\n"; fi
# setTextAttributes.bash bold green; printf "\t\t\tUsage:"; setTextAttributes.bash; printf "\n%s\n" "$1"
#
# eof
