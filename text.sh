#!/bin/bash

cd "$(dirname $0)"

if [ "$1" = "-" ]; then
	lastAction=$3
	input=$(echo -e "0line0\n$2" | sed -E "s/[[:space:][:punct:]]+/\n/g" | choose -m)
	if [ "$input" = "0line0" ]; then
		input=$(echo "$2" |  sed -E "s/[ ]+/ /g" | sed "s/[\"\']//g" | ./dialog_input.sh "edit line")
	fi
elif [ "$1" != "" ]; then
	input=$1
else
	input=$(echo "Input something" | choose -n 0 -m)
fi

input=$(echo "$input" | iconv -f utf8 -t ascii//TRANSLIT)

custommenu=$(sort ./textprofile.log | uniq -c | sort -r | rev | cut -d" " -f 1 | rev | awk -v d="\\\\n" '{s=(NR==1?s:s d)$0}END{print s}')

echo "custom menu is: $custommenu"

menu="Dictionary\nSynonym\nExcerpt\nTranslation\nSpeak\nChatGPT"
if [ "$lastAction" = "" ]; then
	menu="$custommenu\n$menu"
else
	menu="$lastAction\n$custommenu\n$menu"
fi

action=$(echo -e "$menu" | awk '!x[$0]++' | grep -v ^$ | choose -n $(echo -e $menu | wc -l))

if [ "$?" != 0 ]; then
	exit 1
fi

if [ "$lastAction" = "" ]; then
	echo "no last action. logging $action to text profile"
	sed -i '' '50,$d' ./textprofile.log
	echo $action >> ./textprofile.log
fi

if [ "$action" == "Dictionary" ]; then
	./tools/text_dict.sh "$input" "$action"
elif [ "$action" == "Synonym" ]; then
	./tools/text_synonym.sh "$input" "$action"
elif [ "$action" == "Excerpt" ]; then
	./tools/text_excerpt.sh "$input" "$action"
elif [ "$action" == "Translation" ]; then
	./tools/text_translate.sh "$input" "$action"
elif [ "$action" == "Speak" ]; then
	./tools/text_speak.sh "$input" "$action"
elif [ "$action" == "ChatGPT" ]; then
	./tools/text_chatgpt.sh "$input" "$action"
fi
