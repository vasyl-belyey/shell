#! /bin/sh
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
        if [ "$CMD""." == "." ]
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
setPWD() {
        pwd > pwd.txt
        read PWD < pwd.txt
        echo "PWD set: ""$PWD"
}
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
#
#
                        clear
#
ppmDir="$1"
while [ ! -d "$ppmDir" ]
do
	read -p "Enter ppm directory to rename *.ppm files in: " ppmDir
done
#
execCMD "cd ""$ppmDir"; execCMD "pwd"
#
tmpFile="fileList.txt"
ls -1 img*.ppm > "$tmpFile";
#execCMD "less ""$tmpFile"
#
count=1
askYN "Begin numbering from ""$count"" - correct?"
while [ "$answer" = "n" ]
do
	read -p "Enter number to begin numbering from: " count
	askYN "Begin numbering from ""$count"" - correct?"
done
while read line
do
	if [ $count -lt 10 ]; then
		zeros="00000"
	else
		if [ $count -lt 100 ]; then
			zeros="0000"
		else
			if [ $count -lt 1000 ]; then
				zeros="000"
			else
				if [ $count -lt 10000 ]; then
					zeros="00"
				else
					if [ $count -lt 100000 ]; then
						zeros="0"
					else
						zeros=""
					fi
				fi
			fi
		fi
	fi
	newLine="img""$zeros""$count"".ppm"
	#echo "$line"" -> ""$newLine"
	CMD="mv ""$line"" ""$newLine"; echo "$CMD"
	execCMD
	count=$(( count + 1 ))
done < "$tmpFile"
#
ls img*.ppm
execCMD "rm ""$tmpFile"
#
# eof
