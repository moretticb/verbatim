#!/bin/bash

PIPE_FILE=/tmp/text_pipe
PIPE_SEP=";;"

# This tool must output only the selected entry. If you are echoing
# for debugging purposes, remember to remove/comment everything in
# the end


# It receives
#   --menu         as the standard menu
#   --path         as the tool path ($0 from that file)
#   --last-action  as the last action (only for text.sh. Do not use it for tool
# menus)

# Handling parameters
while [ "${1:-}" != "" ]; do
	case "$1" in
		"-l" | "--last-action")
		shift
		lastAction=$1
		;;
		"-m" | "--menu")
		shift
		menu_raw=$1
		;;
		"-p" | "--path")
		shift
		tool_path=$1
		;;
		"-r" | "--prompt")
		shift
		prompt=$1
		;;
		"-P" | "--pipe")
		shift
		pipe="$(echo $1 | sed 's/|//g' | sed "s/[ ]*$PIPE_SEP[ ]*/|/" | cut -sd"|" -f1)"
		[ $(echo $pipe | wc -w) -gt 0 ] && echo "$pipe" | tr " " "\n" > $PIPE_FILE
		;;
	esac
	shift
done



tool=$(echo $tool_path | rev | cut -d"/" -f 1 | rev)

custommenu="$(grep "$tool" ./textprofile.log | sort | uniq -c | sort -r | sed "s/^[[:space:]]*[0-9]* [^ ]* //g" | awk -v d="\\\\n" '{s=(NR==1?s:s d)$0}END{print s}')"


menu="$menu_raw"
# if no last action
if [ "$lastAction" = "" ]; then
        menu="$custommenu\n$menu"
else
        menu="$lastAction\n$custommenu\n$menu"
fi

if [ -f $PIPE_FILE ]; then
	# next part of the pipe
	piping=("-o" "$(head -1 $PIPE_FILE)")

	# rest of the pipe
	sed -i '' '1d' $PIPE_FILE

	# if pipe file is empty, then remove
	[ $(cat $PIPE_FILE | wc -l) = 0 ] && rm $PIPE_FILE
	
fi

menu_size=$(echo -e $menu | wc -l)
menu=$(echo -e "$menu" | awk '!x[$0]++' | grep -v ^$)
action=$(echo -e "$menu" | choose -n $menu_size -p "$prompt" "${piping[@]}" -m | head -1)


# deetecting pipe
if [ $(echo -e "$menu" | choose -o "$action" | wc -l) = 0 ]; then
	if [[ "$action" == *"$PIPE_SEP"* ]]; then
		action="$($0 --menu "$menu_raw" --pipe "$action")"
	else
		exit 1
	fi
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
