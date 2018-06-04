askProceed() {
	if [ $# -gt 0 ]; then
		if ! askYNsilent "\t\t\t\t\t\t\tProceed?"; then exit 13; fi
	else
		if ! askYN "\t\t\t\t\t\t\tProceed?"; then exit 13; fi
	fi
}
