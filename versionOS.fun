versionOS() {
	local retVal=""
	if isMac; then
		local ProductName ProductVersion BuildVersion
		local iLine=-1
		sw_vers | while read aLine; do
			((iLine++))
			# echo "#$iLine = '$aLine'"
			case "$iLine" in
				0)
					ProductName=( $aLine )
					ProductName[0]=""
					ProductName="${ProductName[*]}"
					ProductName=${ProductName:1:999}
# echo "ProdName = '$ProductName'"
				;;
				1)
					ProductVersion=( $aLine )
					ProductVersion=${ProductVersion[1]}
# echo "ProdVer = '$ProductVersion'"
					retVal=$ProductVersion
					retVal=${retVal//./ }
					echo "${retVal[*]}"
				;;
				2)
					BuildVersion=( $aLine )
					BuildVersion=${BuildVersion[1]}
# echo "BuildVersion = '$BuildVersion'"
				;;
			esac
		done
	else
		retVal="Not a MAC OS X.  TBD..."
	fi
	#
}
