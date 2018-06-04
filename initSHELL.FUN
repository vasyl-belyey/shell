#! /bin/bash
#
# Functions:
dirZ=$(pwd)
if dirMY=$(find . -name shell); then cd "$dirMY"; fi
#
. isInteger.fun
. doCMD.fun
doCMD "chmod +x *.fun"
doCMD "chmod +x *.FUN"
doCMD "chmod +x *.bash"
doCMD "chmod +x *.sh"
. dirName.fun
. printColored.fun
. exists.fun
#
#
# Main:
# dirMY=$(dirName "$0")
dirMY=$(pwd)
#
if [[ "$PATH" = *"$dirMY"* ]]; then
	printColored green "This shell directory is already on PATH = '" yellow "$PATH" green "'.\n\n"
else
	export PATH=$dirMY:$PATH
	printColored green "This shell directory is not on PATH = '" yellow "$PATH" green "'.\n\n"
	if [ -f "$HOME/.bash_aliases" ]; then
		fil="$HOME/.bash_aliases"
	else
		fil="$HOME/.bashrc"
	fi
	if exists -f "$fil"; then
		printColored yellow "\t adding to '" green "$fil" yellow "' ...\n\n"
		echo "# VB: $(date)" >> "$fil"
		echo "export PATH=$PATH" >> "$fil"
		echo "# eof" >> "$fil"
		printColored yellow "\t loading '" green ". $fil" yellow "'...\n\n"
		. "$fil"
	else
		printColored yellow "\t adding to '" green "$fil" yellow "'" red " FAILED.\n\n"
		retCode=13
	fi
fi
# END
cd "$dirZ"
return $retCode
# eof
