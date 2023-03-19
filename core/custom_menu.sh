#!/bin/bash

# This tool must output only the selected entry. If you are echoing
# for debugging purposes, remember to remove/comment everything in
# the end


# It receives
# $1 as the standard menu
# $2 as the tool path ($0 from that file)
# $3 as the last action (only for text.sh. Do not use it for tool menus)


tool=$(echo $2 | rev | cut -d"/" -f 1 | rev)

menu="$1"
lastAction="$3"
custommenu="$(grep "$tool" ./textprofile.log | sort | uniq -c | sort -r | sed "s/^[[:space:]]*[0-9]* [^ ]* //g" | awk -v d="\\\\n" '{s=(NR==1?s:s d)$0}END{print s}')"


# if no last action
if [ "$3" = "" ]; then
        menu="$custommenu\n$menu"
else
        menu="$lastAction\n$custommenu\n$menu"
fi


action=$(echo -e "$menu" | awk '!x[$0]++' | grep -v ^$ | choose -n $(echo -e $menu | wc -l))


if [ "$?" != 0 ]; then
        exit 1
fi


# no last action. logging $action to text profile
if [ "$lastAction" = "" ]; then

	# Keeping at most $entries entries so the file does not get huge
	entries=50
        sed -i '' "$entries,\$d" ./textprofile.log

	# logging: which tool and chosen menu entry
        echo "$tool $action" >> ./textprofile.log
fi


echo $action
