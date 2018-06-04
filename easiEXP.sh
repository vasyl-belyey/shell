#! /bin/sh
#
#
askYN() {
        answer=""
        while [ "$answer" != "y" ] && [ "$answer" != "n" ]
        do
                echo; echo; echo
                read -p "$1"" (y/n) " answer
        done
}
#
echoHigh() {
        echo; echo; echo;
        echo "$1"
        if [ "$2""." != "." ]
                then
                        echo; echo; echo;
        fi
}
#
execCMD() {
        echo; echo; echo
        if [ "$1""." != "." ]
                then
                        CMD="$1"
        fi
        if [ "$CMD". == "." ]
                then
                        echo "No command given"
                        exit
                else
                        echo "Executing '""$CMD""'..."
                        $CMD
                        iExitCode=$?
                        echo "Exit code = ""$iExitCode"
                        if [ $iExitCode -eq 0 ]
                                then
                                        echo;
                                else
                                        if [ "$2""." = "." ]
                                                then
                                                        echo; echo; echo
                                                        exit $iExitCode
                                        fi
                        fi
                        echo "'""$CMD""' done."
        fi
echo; echo; echo
}
#
#
clear
#
cDir=$(pwd)
echoHigh "USER = '""$USER""' in pwd = '""$cDir""'" 1
#
etDir="/home/""$USER""/Desktop/Echotec/vasyl"
if [ "$cDir" != "$etDir" ]; then
	execCMD "cd ""$etDir"
fi
#
# eof
