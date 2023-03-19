#!/bin/bash

input="$1"
lastAction="$2"

echo "Speak: $input"

lang_menu="en"
lang_menu="$lang_menu\npt"
lang_menu="$lang_menu\nit"
lang_menu="$lang_menu\nes"
lang_menu="$lang_menu\nfr"
lang_menu="$lang_menu\nde"
lang_menu="$lang_menu\nnl"

lang=$(core/custom_menu.sh "$lang_menu" "$0" "")

if [ $? = 1 ]; then
	exit 1;
fi

wget -q -U Mozilla -O /tmp/text_tts.mp3 "https://translate.google.com.vn/translate_tts?ie=UTF-8&q=$input&tl=$lang&client=tw-ob" && afplay /tmp/text_tts.mp3 && rm /tmp/text_tts.mp3 && kill $(ps -eo pid,command | grep choose | grep -v grep | cut -d" " -f 1) &


willkill=$(echo -e "Kill process\nNo kill" | choose)

if [ "$willkill" = "Kill process" ]; then
	kill $(ps aux | grep tts | grep -v grep | head -1 | sed -E "s/[[:space:]]+/ /g" | cut -d" " -f 2)
fi

./text.sh "-" "$input" "$lastAction"
