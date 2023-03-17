#!/bin/bash

path="/opt/homebrew/bin/"

echo "Speak: $1"
lang=$(echo -e "en\npt\nit\nes\nfr\nde" | $path/choose -m)

if [ $? = 1 ]; then
	exit 1;
fi

$path/wget -q -U Mozilla -O /tmp/text_tts.mp3 "https://translate.google.com.vn/translate_tts?ie=UTF-8&q=$1&tl=$lang&client=tw-ob" && afplay /tmp/text_tts.mp3 && rm /tmp/text_tts.mp3 && kill $(ps -eo pid,command | grep $path/choose | grep -v grep | cut -d" " -f 1) &


willkill=$(echo -e "Kill process\nNo kill" | $path/choose)

if [ "$willkill" = "Kill process" ]; then
	kill $(ps aux | grep tts | grep -v grep | head -1 | sed -E "s/[[:space:]]+/ /g" | cut -d" " -f 2)
fi

$HOME/scripts/text.sh "-" "$1" "$2"
