lsPort() {
	local usageLine="lsPort [portNo=13713]"
        local aPort="$1"
        if [ -z "$aPort" ]; then aPort="13713"; fi
        local CMD="lsof -i | grep :""$aPort"
        local t0="$(date +%s)"
        local retCode=13
        local aColor=green
        #
        CMD="sudo netstat -anp | grep LISTENING" # | grep ""$aPort"
        printColored.bash yellow "\tlsPort: CMD='""$CMD""'...\n"
        sudo netstat -anp | grep LISTENING # | grep "$aPort"
        retCode=$?; if [ $retCode -eq 0 ]; then aColor=green; else aColor=red; fi
        printColored.bash $aColor "\tlsPort: retCode='""$retCode""'.\n"
        #
        CMD="lsof -i | grep :""$aPort"
        printColored.bash yellow "\tlsPort: CMD='""$CMD""'...\n"
        lsof -i | grep ":$aPort "
        retCode=$?; if [ $retCode -eq 0 ]; then aColor=green; else aColor=red; fi
        printColored.bash $aColor "\tlsPort: retCode='""$retCode""'.\n"
        #
        t0=$(( $(date +%s) - t0 ))
        printColored.bash green "\tIt took ""$(printSeconds.bash $t0)""\n"
        # if $CMD; then
        #       printColored.bash green "\t\tCMD='""$CMD""' OK\n"
        # else
        #       printColored.bash red "\t\tCMD='""$CMD""' FAILED\n"
        # fi
        return $retCode
}
