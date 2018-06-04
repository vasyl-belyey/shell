#! /bin/bash
#
#
#
clear
printf "\n\n\n"
# Main:
jobs
# pc=( $(jobs) )
read -p "             Job number to fg:  " answer
printf "\n\n\n"
if [ -z "$answer" ]; then
	fg
else
	fg "$answer"
fi
#
# END
# printf "\n\n\n"
# eof
