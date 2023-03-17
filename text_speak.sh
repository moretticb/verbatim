#!/bin/bash


echo "Speak: $1"
lang=$(echo -e "en\npt\nit\nes\nfr\nde" | choose -m)

if [ $? = 1 ]; then
	exit 1;
fi

wget -q -U Mozilla -O /tmp/text_tts.mp3 "https://translate.google.com.vn/translate_tts?ie=UTF-8&q=$1&tl=$lang&client=tw-ob" && afplay /tmp/text_tts.mp3 && rm /tmp/text_tts.mp3 && kill $(ps -eo pid,command | grep choose | grep -v grep | cut -d" " -f 1) &


willkill=$(echo -e "Kill process\nNo kill" | choose)

if [ "$willkill" = "Kill process" ]; then
	kill $(ps aux | grep tts | grep -v grep | head -1 | sed -E "s/[[:space:]]+/ /g" | cut -d" " -f 2)
fi

./text.sh "-" "$1" "$2"
