#!/bin/bash

path="/opt/homebrew/bin/"
export PATH="$PATH:$path"

if [ "$1" = "-" ]; then
	lastAction=$3
	input=$(echo -e "0line0\n$2" | sed -E "s/[[:space:][:punct:]]+/\n/g" | $path/choose -m)
	if [ "$input" = "0line0" ]; then
		input=$(echo "$2" |  sed -E "s/[ ]+/ /g" | sed "s/[\"\']//g" | $HOME/scripts/dialog_input.sh "edit line")
	fi
elif [ "$1" != "" ]; then
	input=$1
else
	input=$(echo "Input something" | $path/choose -n 0 -m)
fi

input=$(echo "$input" | iconv -f utf8 -t ascii//TRANSLIT)

custommenu=$(sort $HOME/scripts/textprofile.log | uniq -c | sort -r | rev | cut -d" " -f 1 | rev | awk -v d="\\\\n" '{s=(NR==1?s:s d)$0}END{print s}')

echo "custom menu is: $custommenu"

menu="Dictionary\nSynonym\nExcerpt\nTranslation\nSpeak\nChatGPT"
if [ "$lastAction" = "" ]; then
	menu="$custommenu\n$menu"
else
	menu="$lastAction\n$custommenu\n$menu"
fi

action=$(echo -e "$menu" | awk '!x[$0]++' | grep -v ^$ | $path/choose -n $(echo -e $menu | wc -l))

if [ "$?" != 0 ]; then
	exit 1
fi

if [ "$lastAction" = "" ]; then
	echo "no last action. logging $action to text profile"
	sed -i '' '50,$d' $HOME/scripts/textprofile.log
	echo $action >> $HOME/scripts/textprofile.log
fi

if [ "$action" == "Dictionary" ]; then
	$HOME/scripts/text_dicio.sh "$input" "$action"
elif [ "$action" == "Synonym" ]; then
	$HOME/scripts/text_sinonimos.sh "$input" "$action"
elif [ "$action" == "Excerpt" ]; then
	$HOME/scripts/text_excerpt.sh "$input" "$action"
elif [ "$action" == "Translation" ]; then
	$HOME/scripts/text_translate.sh "$input" "$action"
elif [ "$action" == "Speak" ]; then
	$HOME/scripts/text_speak.sh "$input" "$action"
elif [ "$action" == "ChatGPT" ]; then
	$HOME/scripts/text_chatgpt.sh "$input" "$action"
fi
