#!/bin/bash

path="/opt/homebrew/bin/"

echo "Ask: $1"

line="$(echo $1 | ~/scripts/text_chatgpt_tool.sh | fold -w 60 -s | $path/choose -n 10 -s 24)"

if [ $? = 1 ]; then
        exit 1;
fi

echo "Answer: $line"

#$(pwd)/scripts/text.sh "-" "$transl" "$2"
~/scripts/text.sh "-" "$line" "$2"
