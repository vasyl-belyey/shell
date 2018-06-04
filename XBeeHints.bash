#! /bin/bash
#
# F:
#
# Init:
usageLine="$(basename "$0")"" [- | c(ommands) | m(anual)] (default = all)"
manDoc="$(dirname "$0")""/90000982_A.pdf"
cmdDoc="$(dirname "$0")""/22AT_Commands.pdf"
#
arg1="$1"
case "$arg1" in
	"")
		findViewer.bash "$manDoc" &
		findViewer.bash "$cmdDoc" &
	;;
	"c")
		findViewer.bash "$cmdDoc" &
	;;
	"m")
		findViewer.bash "$manDoc" &
	;;
	"-")
		printUsage.bash "$usageLine"
		exit 13
	;;
	*)
		printUsage.bash "$usageLine" "Unrecognized argument '""$arg1""'."
		exit 13
	;;
esac
#
printf "\n\n\n\t\t\tSUCCESS.  arg1 = '%s'.\n\n\n" "$arg1"
#
# eof
