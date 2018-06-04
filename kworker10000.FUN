#! /bin/bash
# . isInteger.fun
echo "Current value of /proc/sys/vm/dirty_writeback_centisecs:"
cat /proc/sys/vm/dirty_writeback_centisecs
read -p "             Hit ENTER when ready to REBOOT (any other key to abort this):  " -n1 answer
echo
if [ -z "$answer" ]; then
	sudo reboot "echo 10000 > /proc/sys/vm/dirty_writeback_centisecs"
	exit
fi
