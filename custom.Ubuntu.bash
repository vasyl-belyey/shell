#! /bin/bash
#
# Functions:
. includeAll.fun
#
isInteractive() {
	local arg=$fInteractive
	if [ -z "$arg" ]; then
		arg=$1
		if ! isInteger "$arg"; then
			eval "arg=\$$arg"
		fi
	fi
	if isInteger "$arg" && [ $arg -ne 0 ]; then return 0; else return 13; fi
}
###
checkKworker() {
	local pc=""
	if ! pc=$(cat /proc/sys/vm/dirty_writeback_centisecs) || ! isInteger "$pc" || [ $pc -lt 10000 ]; then
		sudo echo 10000 > /proc/sys/vm/dirty_writeback_centisecs
		return $?
	fi
}
###
loadPkgList() {
	printColored yellow "\n\t Loading '" white "$filpkgList" yellow "' ...\n"
	pkgList=( $(cat "$filpkgList") )
	return $?
}
###
checkPackage() {
	local aPKG="$1"
	printColored white "\t\t\t$aPKG : " yellow "checking ...\n"
	case "$aPKG" in
		# "libusb-1.0-0-dev")
		libusb-1*)
			if pc=$(sudo find / -name "libusb-1*.so" 2>/dev/null); then
				printColored white "$aPKG" green "  installed\n"
			else
				printColored white "\t\t$aPKG" red "  NOT installed."
				return 13
			fi
		;;
		docker)
			if pc=$(man wmdocker 2>/dev/null); then
				printColored white "$aPKG" green "  installed\n"
			else
				printColored white "\t\t$aPKG" red "  NOT installed."
				return 13
			fi
		;;
		openssh-server)
			# if pc=$(ls -l /etc/udev/rules.d/"$aPKG" 2>/dev/null); then
			# 	printColored white "$aPKG" green "  installed\n"
			# else
				printColored white "\t\t$aPKG" red "  NOT installed."
				return 13
			# fi
		;;
		70-asi-cameras.rules)
			if pc=$(ls -l /etc/udev/rules.d/"$aPKG" 2>/dev/null); then
				printColored white "$aPKG" green "  installed\n"
			else
				printColored white "\t\t$aPKG" red "  NOT installed."
				return 13
			fi
		;;
		libASICamera2.so | libphNativeLinux64.so)
			if pc=$(ls -l /usr/bin/"$aPKG" 2>/dev/null); then
				printColored white "$aPKG" green "  installed\n"
			else
				printColored white "\t\t$aPKG" red "  NOT installed."
				return 13
			fi
		;;
		espeak)
			if pc=$(espeak "installed" 2>/dev/null); then
				printColored white "$aPKG" green "  installed\n"
			else
				printColored white "\t\t$aPKG" red "  NOT installed."
				return 13
			fi
		;;
		gdrive-linux-*)
			# if pc=$(which "gdrive"); then
			if gdrive about; then
				printColored white "$aPKG" green "  installed\n"
			else
				printColored white "\t\t$aPKG" red "  NOT installed."
				return 13
			fi
		;;
		java | javac | ppmtompeg | at)
			if pc=$(which "$aPKG"); then printColored white "$aPKG" green "  installed\n"; else printColored white "\t\t$aPKG" red "  NOT installed."; return 13; fi
		;;
		*)
			if pc=$(which "$aPKG"); then
				printColored white "$aPKG" green "  installed\n"
			else
				printColored white "\t$aPKG" yellow "  seems NOT installed." white "  Checking with apt-cache ...\n"
				if ! pc=$(apt-cache --names-only search . | grep -w "$aPKG"); then
					printColored white "\t\t$aPKG" red "  NOT installed."
					return 13
				else
					printColored white "\t$aPKG" green "  installed\n"
				fi
			fi
		;;
	esac
}
###
installPackage() {
	local aPKG="$1"
	printColored white "\t\t\t$aPKG : " yellow "installing ...\n"
	case "$1" in
		gdrive-linux-*)
			# local URL="https://docs.google.com/uc?id=0B3X9GlR6EmbnQ0FtZmJJUXEyRTA&export=download" fil="gdrive"
			local URL="https://docs.google.com/uc?id=0B3X9GlR6EmbnQ0FtZmJJUXEyRTA" fil="gdrive"
			doCMD "wget $URL -O $fil" 1 1
			doCMD "chmod +x $fil" 1 1
			doCMD "./$fil about" 1 1
			doCMD "sudo mv $fil /usr/local/bin/"
			doCMD "$fil about" 1 1
		;;
		ppmtompeg)
			doCMD "sudo apt-get install netpbm" 1 1
		;;
		java)
			doCMD "sudo apt-get install default-jre" 1 1
		;;
		javac)
			doCMD "sudo apt-get install default-jdk" 1 1
		;;
		70-asi-cameras.rules)
			doCMD "sudo cp -p $HOME/VBlibs/Apps/PinHoleCamera/Resources/$aPKG /etc/udev/rules.d/" 1 1
		;;
		libASICamera2.so)
			doCMD "sudo cp -p $HOME/VBlibs/Apps/PinHoleCamera/Resources/$aPKG /usr/bin/" 1 1
		;;
		libphNativeLinux64.so)
			doCMD "sudo cp -p $HOME/VBlibs/Apps/PinHoleCamera/Resources/$aPKG /usr/bin/" 1 1
		;;
		*)
			doCMD "sudo apt-get install $1" 1 1
		;;
	esac
	printColored white "\t\t\t$aPKG : " green "installed.\n"
}
###
#
# Init:
clear
printf "\n\n\n"
#
printf "\t\t\t\t\t\t In case kworker misbehaves, see \n\t https://askubuntu.com/questions/176565/why-does-kworker-cpu-usage-get-so-high \n\n\n"
# https://askubuntu.com/questions/176565/why-does-kworker-cpu-usage-get-so-high
#
usageLine="$(basename "$0")"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"" [options] [-P packageName]\n \
	options:\n \
	[-i (interactive request to install an absent package)]"
	exit 13
fi
#
if fInteractive=$(parseOption "-i" $*); then fInteractive=1; else fInteractive=0; fi
#
packageName=$(parseOption "-P" $*)
#
if ! isSudoer; then
	printUsage.bash "$usageLine" "Sorry, $USER, you must be a sudoer."
	exit 13
fi
# doCMD "sudo apt-get update" 1 1
# sudo apt-get update | while IFS= read -r aLine ; do
# done
oneLineCMD.bash "sudo apt-get update"
#
# doCMD checkKworker 0 1
#
filpkgList=$(dirName "$0")/$(basename "$0").pkgList
if ! exists -f "$filpkgList"; then
	printUsage.bash "$usageLine" "Can't load package list: no '$filpkgList' file."
	exit 13
fi
# load filpkgList as pkgList:
doCMD "loadPkgList" 1 1
nPKG=${#pkgList[*]}
for((i=0;i<nPKG;i++)); do
	aPKG=${pkgList[i]}
	if ! [ -z "$packageName" ]; then aPKG="$packageName"; printColored magenta "\n\n\n\t\t\t\t\tChecking ONLY '" yellow "$aPKG" magenta "' ...\n\n"; fi
	if ! checkPackage "$aPKG"; then
		if ! isInteractive || askYNsilent "             Install '$aPKG'?"; then doCMD "installPackage $aPKG" 1 1; fi
	fi
	if ! [ -z "$packageName" ]; then break; fi
done
#
#
# Main:
# END
printf "\n\n\n\t\t\t Bye, $USER!\n\n\n"
# eof
