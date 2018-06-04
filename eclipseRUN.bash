#!/bin/bash
if isMAC.bash; then
	echo isMAC
else
	UBUNTU_MENUPROXY=0
	export UBUNTU_MENUPROXY
fi
###/usr/local/bin/eclipse/eclipse/eclipse
if [ "$USER" != "root" ] && [ -d "/home/vasyl/workspaceEclipse/.metadata" ]; then
	###fiNa="/sda6storage/home/vasyl/workspaceEclipse/.metadata/.plugins/org.eclipse.core.resources/.safetable/org.eclipse.core.resources"
	fiNa="/home/vasyl/workspaceEclipse/.metadata/.plugins/org.eclipse.core.resources/.safetable/org.eclipse.core.resources"
	if [ ! -O "$fiNa" ]; then
		CMD="sudo chown ""$USER"" ""$fiNa"
		###CMD="sudo chown -R ""$USER"" ""/home/vasyl/workspaceEclipse/"
		printf "\n\n\n\t\t\tDOING:\n'%s'...\n" "$CMD"
		$CMD
		if [ $? -ne 0 ]; then exit 13; fi
	fi
	fiNa="/home/vasyl/workspaceEclipse/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.jdt.ui.prefs"
	if [ ! -O "$fiNa" ]; then
		CMD="sudo chown ""$USER"" ""$fiNa"
		printf "\n\n\n\t\t\tDOING:\n'%s'...\n" "$CMD"
		$CMD
		if [ $? -ne 0 ]; then exit 13; fi
	fi
fi
#
nBits=$(getconf LONG_BIT)
if ! isInteger.bash "$nBits"; then
	printColored.bash red "\n\t\t\tBad nBits = '""$nBits""'  :-(\n\n"
	exit 13
fi
#
if [ "$1" = "" ]; then
	if isMAC.bash; then
		# open /Users/vasyl/Applications/eclipse/eclipse/Eclipse.app
		open /Users/vasyl/Applications/Eclipse/Eclipse.app
	else
		if [ "$2" = "" ]; then
			/home/vasyl/Downloads/Install/Eclipse-"$nBits"/eclipse/eclipse &
		else
			/Ubuntu-10_04-32bit/home/vasyl/Downloads/Eclipse-32/eclipse/eclipse &
		fi
	fi
else
	if isMAC.bash; then
		open /Users/vasyl/Applications/eclipse/eclipse/Eclipse.app
	else
		if [ "$2" = "" ]; then
			/home/vasyl/Downloads/Install/Eclipse-"$nBits"/eclipse/eclipse
		else
			/Ubuntu-10_04-32bit/home/vasyl/Downloads/Eclipse-32/eclipse/eclipse
		fi
	fi
fi
