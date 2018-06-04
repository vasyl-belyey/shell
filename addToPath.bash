#! /bin/bash
#
# Functions:
# if ! [ -f dirName.fun ]; then
# 	printf "\n\t\t\t $(basename "$0") needs be run from its directory.\n\t\t First cd $(dirname "$0")\n\n"
# 	exit 13
# fi
cd "$(dirname "$0")"
#
. doCMD.fun
doCMD "chmod +x *.fun"
doCMD "chmod +x *.FUN"
doCMD "chmod +x *.bash"
doCMD "chmod +x *.sh"
. dirName.fun
. printColored.fun
#
#
# Main:
dirZ=$(pwd)
dirMY=$(dirName "$0")
# echo " dirMY = '$dirMY'"
#
if ! [[ "$PATH" = *"$dirMY"* ]]; then
	printColored green "This shell directory is already on PATH = '" yellow "$PATH" green "'.\n\n"
else
	printColored green "This shell directory is not on PATH = '" yellow "$PATH" green "'.\n\n"
fi
# END
# eof
