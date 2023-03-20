#!/bin/bash

tool_name="ChatGPT"

# Handling parameters
while [ "${1:-}" != "" ]; do
        case "$1" in
                "-i" | "--input")
                shift
                input=$1
                ;;
        esac
        shift
done


echo "Ask: $input"

line="$(echo $input | src/text_chatgpt_tool.sh | fold -w 60 -s | choose -n 10 -s 24)"

if [ $? = 1 ]; then
        exit 1;
fi

echo "Answer: $line"

./text.sh --input "$line" --last-action "$tool_name"
