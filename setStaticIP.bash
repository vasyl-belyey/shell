#! /bin/bash
#
# Functions:
#
. "$(vbShellDir.bash)""/doCMD.fun"
. "$(vbShellDir.bash)""/exists.fun"
. "$(vbShellDir.bash)""/askYN.fun"
. "$(vbShellDir.bash)""/askYNsilent.fun"
. "$(vbShellDir.bash)""/askProceed.fun"
. "$(vbShellDir.bash)""/printFile.fun"
. "$(vbShellDir.bash)""/isMac.fun"
. "$(vbShellDir.bash)""/isInteger.fun"
. "$(vbShellDir.bash)""/stringContains.fun"
. "$(vbShellDir.bash)""/indexOf.fun"
. "$(vbShellDir.bash)""/parseOption.fun"
. "$(vbShellDir.bash)""/printSeconds.fun"
. "$(vbShellDir.bash)""/printColored.fun"
. "$(vbShellDir.bash)""/isSudoer.fun"
. "$(vbShellDir.bash)""/lsofVB.fun"
. "$(vbShellDir.bash)""/cursorGoTo.fun"
#
# Init:
usageLine="$(basename "$0")"" ipSTATIC"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
ipSTATIC="$1"
if [ -z "$ipSTATIC" ]; then
	printUsage.bash "$usageLine" "argument ipSTATIC absent"
	exit 13
fi
#
fileIF="/etc/network/interfaces"
if ! exists -f "$fileIF"; then
	printUsage.bash "$usageLine" "interface file '""$fileIF""' does not exist"
	exit 13
fi
#
#
# Main:
doCMD "sudo cp -pv ""$fileIF"" ""$fileIF"".$(date -u +"%Y%m%d")"".bak"
printf "\n\n\n\tNow add/edit the '%s' file as follows:\n\n" "$fileIF"
# printf "%s\n" "\
echo "# This file describes the network interfaces available on your system"
echo "# and how to activate them. For more information, see interfaces(5)."
echo ""
echo "# The loopback network interface"
echo "auto lo"
echo "iface lo inet loopback"
echo ""
echo "# The primary network interface"
echo "auto eth0"
echo "iface eth0 inet static"
echo "address 192.168.0.X"
echo "netmask 255.255.255.0"
echo "network 192.168.0.0"
echo "broadcast 192.168.0.255"
echo "gateway 192.168.0.X"
echo "dns-nameservers 192.168.0.X"
#
printf "\n\n\nuse '%s' instead of '192.168.0.X'\n" "$ipSTATIC"
askProceed silent
doCMD "sudo vi ""$fileIF"
doCMD "sudo /etc/init.d/networking restart"
#
# END
# eof
