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
makeBuildXML() {
	local fil=$dirLib/build.xml
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "$fil"
	echo "<project name=\"ButtonDemo\" default=\"default\" basedir=\".\">" >> "$fil"
	echo "    <import file=\"nbproject/build-impl.xml\"/>" >> "$fil"
	echo >> "$fil"
	echo "    <taskdef name=\"bundleapp\"" >> "$fil"
	echo "             classname=\"com.oracle.appbundler.AppBundlerTask\"   " >> "$fil"
	echo "             classpath=\"lib/appbundler-1.0.jar\" />" >> "$fil"
	echo "" >> "$fil"
	echo "    <target name=\"bundle-buttonDemo\">" >> "$fil"
	echo "        <bundleapp outputdirectory=\"dist\"" >> "$fil"
	echo "            name=\"ButtonDemo\"" >> "$fil"
	echo "            displayname=\"Button Demo\"" >> "$fil"
	echo "            identifier=\"components.ButtonDemo\"" >> "$fil"
	echo "            mainclassname=\"components.ButtonDemo\">" >> "$fil"
	echo "            <classpath file=\"dist/ButtonDemo.jar\" />" >> "$fil"
	echo "        </bundleapp>" >> "$fil"
	echo "    </target>" >> "$fil"
	echo "" >> "$fil"
	echo "</project>" >> "$fil"
	doCMD "less $fil"
}
#
# Init:
usageLine="$(basename "$0")"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
#
# Main:
dirWork="$(pwd)"
nameApp=$(basename "$dirWork")
if isMac; then
	dirLib=$dirWork/deploy
	if exists -d "$dirLib"; then doCMD "rm -Rf $dirLib"; fi
	# doCMD "mkdir $dirLib"
	jdk=$(/usr/libexec/java_home)
	doCMD "$jdk/bin/javapackager -version"
	# doCMD "$jdk/bin/javapackager -deploy -native dmg -srcfiles ShowTime.jar -appclass ShowTime -name ShowTime -outdir deploy -outfile ShowTime -v"
	doCMD "$jdk/bin/javapackager -deploy -native dmg -srcfiles $nameApp.jar -appclass $nameApp -name $nameApp -outdir deploy -outfile $nameApp -v"
	dirBundles=$dirLib/bundles
	CMD="ls $dirBundles/*.dmg"
	doCMD "$CMD"
	filDMG=$($CMD)
	doCMD "cp -pv $filDMG $dirWork/"
else
	dirLib=$dirWork/lib
	if exists -d "$dirLib"; then doCMD "rm -Rf $dirLib"; fi
	doCMD "mkdir $dirLib"
	filBundler=$(vbShellDir.bash)/../java/appbundler-1.0.jar
	doCMD "cp -pv $filBundler $dirLib"
	doCMD "makeBuildXML"
	doCMD "ant -f $dirLib/build.xml" 1 3
fi
#
# END
askProceed 1
if exists -d "$dirLib"; then doCMD "rm -Rf $dirLib"; fi
# eof
