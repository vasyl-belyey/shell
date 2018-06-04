#! /bin/bash
#
# Init:
usageLine="$(basename "$0")"" [-|dirName]"
#
#watch -n 1 -d "du -k /home/vasyl/testData/ppmToProcess/; echo; ps -C sshd; echo; ifconfig | head -3; echo; echo; ls -l /home/vasyl/testData/ppmToProcess/ | tail"
#watch -n 1 -d "du -k /home/vasyl/testData/ppmToProcess/; echo; ps -C sshd; echo; ifconfig | grep "inet addr"; echo; echo; ls -l /home/vasyl/testData/ppmToProcess/ | tail"
#
dirToWatch=/home/vasyl/testData/ppmToProcess/
if [ "$1" != "" ]; then
	if [ -d "$1" ]; then
		dirToWatch="$1"
	else
		# Help?
		arg1="$1"
		if [ "${arg1:0:1}" = "-" ]; then
			printUsage.bash "$usageLine"
			exit 13
		fi
	fi
fi
#
#
watch -n 1 -d "du -k $dirToWatch; echo; ps -C sshd; echo; ifconfig; echo; echo; ls -lk $dirToWatch/*.ppm | tail -3"
#
# eof
