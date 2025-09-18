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

#line="$(echo $input | src/text_chatgpt_tool.sh | fold -w 60 -s | choose -n 10 -s 24)"
gui_wid=70
font_size=18
fold_size=120
max_rows=35

rm -f /tmp/chatgpt_output.txt

# while IFS= read -r linestream
# do
# 	# kill it to reopen at every stream update
# 	ps -eo pid,command | grep "choose" | grep -v grep | awk '{print $1}' | xargs kill
# 	
# 	echo $linestream | fold -w $fold_size  >> /tmp/chatgpt_output.txt
# 
# 	output_rows=$(cat /tmp/chatgpt_output.txt | wc -l)
# 	if [ $output_rows -gt $max_rows ]; then
# 		output_rows=$max_rows
# 	fi
# 
# 	cat /tmp/chatgpt_output.txt | choose -n $output_rows -s $font_size -w $gui_wid -p "⏳" &
# 	
# done < <(echo $input | src/text_chatgpt_tool.sh)

echo $input | src/text_chatgpt_tool.sh >> /tmp/chatgpt_output.txt &
sleep 1

while : ; do
	cat /tmp/chatgpt_output.txt | sed "s/^$/\t/g" | fold -w $fold_size | choose -n $max_rows -s $font_size -w $gui_wid -p "⏳ $input" && ps -eo ppid,command | grep gpt | grep -v grep | awk '{print $1}' | xargs kill &

	sleep 2

	# kill choose-gui to reopen at every stream update
	#ps -eo pid,command | grep "choose" | grep -v grep | awk '{print $1}' | xargs kill

	ps -eo pid,command | grep curl | grep stream | grep -v grep || break
done


ps -eo pid,command | grep "choose" | grep -v grep | awk '{print $1}' | xargs kill
line="$(cat /tmp/chatgpt_output.txt | sed "s/^$/\t/g" | fold -w $fold_size | choose -n $max_rows -w $gui_wid -s $font_size -p "$input" )"

if [ $? = 1 ]; then
        exit 1;
fi

echo "Answer: $line"

./text.sh --input "$line" --last-action "$tool_name"
