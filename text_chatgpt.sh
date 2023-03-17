#!/bin/bash


echo "Ask: $1"

line="$(echo $1 | ./text_chatgpt_tool.sh | fold -w 60 -s | choose -n 10 -s 24)"

if [ $? = 1 ]; then
        exit 1;
fi

echo "Answer: $line"

./text.sh "-" "$line" "$2"
