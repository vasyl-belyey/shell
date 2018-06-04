#! /bin/sh
#
clear
#
#switchIP="158.39.70.244"
switchIP="158.39.70.161"
userName="$USER"
portNO="$2"
powerOn="$1"
outFile="$0"".out.html"
# who?
if [ "$userName" = "kstdev" ]
	then
		userName="easi"
		echo "Assuming user '""$userName""'..."
fi
#
echo "Hi ""$userName"","; echo; echo; echo;
#
while [ "$portNO" != "1" ] && [ "$portNO" != "2" ] && [ "$portNO" != "3" ] && [ "$portNO" != "4" ]
	do
		echo "Invalid argument 2 (portNO) ='""$portNO""'"
		echo "   valid values: 1 - Blixten or 2 - RALreceivers or 3 - Oscilloscope or 4 - unused"
		#exit 1
		read -p "Enter valid value [1/2/3/4] " portNO
	done
#
# port name:
portName="UNKNOWN"
case $portNO in
1)
	portName="Blixten";;
2)
	portName="RAL receivers";;
3)
	portName="Oscilloscope";;
4)
	portName="Unused port";;
esac
#
while [ "$powerOn" != "0" ] && [ "$powerOn" != "1" ]
	do
		echo "Invalid argument 1 (powerOn) ='""$powerOn""'"
		echo "   valid values: 0 - OFF or 1 - ON"
		#exit 1
		read -p "Enter valid value [0/1] " powerOn
	done
#
# action name:
actionName="UNKNOWN"
case $powerOn in
0)
	actionName="OFF";;
1)
	actionName="ON";;
esac
#
# confirm:
echo; echo;echo;
echo "       ""$userName"", you want to turn ""$portName"" ""$actionName"
answer=""
while [ "$answer" != "y" ] && [ "$answer" != "n" ]
	do
		read -p "             Is it correct? (y/n) " answer
	done
echo; echo; echo;
if [ "$answer" = "n" ]; then
	echo "Okay.  Bye, ""$userName""!"
	echo; echo; echo;
	exit 1
fi
echo; echo; echo;
#
read -p "$userName""@""$switchIP""'s password: " pswd
#
CMD="curl http://""$userName"":""$pswd""@""$switchIP""/SetPower.cgi?p""$portNO""=""$powerOn"
#echo "$CMD"
$CMD > "$outFile"
# check:
#if [ "$?" != "0" ]
#	then
#		echo; echo; echo; echo "Error"
#		exit 1
#fi
# more check:
read answer < "$outFile"
rm "$outFile"
#echo "$answer"
if echo "$answer" | grep "Unauthorized"
	then
		echo; echo; echo; echo "Error"
		exit 1
fi
#
# Report
echo; echo; echo;
echo "Success.  ""$portName"" has been turned ""$actionName""."
echo; echo; echo;
#
if [ $powerOn -eq 0 ]
	then
		answer=""
		while [ "$answer" != "y" ] && [ "$answer" != "n" ]
			do
				read -p "Turn it back ON? [y/n] " answer
			done
		if [ "$answer" = "y" ]
			then
				CMD="$0"" 1 ""$portNO"
				echo "$CMD"
				$CMD
		fi
fi
#
exit
###curl http://"$userName":passWd@158.39.70.161/SetPower.cgi?p1=0
