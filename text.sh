#!/bin/bash


# Handling parameters
while [ "${1:-}" != "" ]; do
	case "$1" in
		"-l" | "--last-action")
		shift
		lastAction=$1
		;;
		"-i" | "--input")
		shift
		inputLine=$1
		;;
	esac
	shift
done


# Going to the directory of the current script, so every relative paths from
# this and other scripts are with respect to such path
cd "$(dirname $0)"


# If there is some input and last action is defined, i.e., if there is some
# output being chained for the next tool, gives the option to either edit the
# line, or to chain as is.
#
# Else, if there is some input, but no last action, start from here
#
# Else, prompts for an input to start chaining text
if [ -n "$lastAction" ] && [ -n "$inputLine" ]; then
	main_prompt="[l]ine, [e]dit line, [c]opy&exit, [p]aste"
	input=$(echo -e "$inputLine" | sed -E "s/[[:space:][:punct:]]+/\n/g" | fold -sw 80 | choose -m -s 20 -p "$main_prompt")

	[ "$input" = "-c" ] && echo "$inputLine" | pbcopy && exit 0

	if [ "$input" = "-e" ]; then
		input=$(echo "$inputLine" |  sed -E "s/[ ]+/ /g" | sed "s/[\"\']//g" | core/dialog_input.sh "Edit line")
	elif [ "$input" = "-l" ]; then
		input="$inputLine"
	fi
elif [ -n "$inputLine" ]; then
	input=$inputLine
else
	input=$(echo "." | choose -n -1 -m -s 16 -p "-X: [p]aste")
	if [ "$input" = "-p" ]; then
		input="$(pbpaste)"
	fi
fi



# If no input, then exit
[ -z "$input" ] && exit 0



# Avoiding problems due to weird charset encoding
input="$(echo "$input" | iconv -f utf8 -t ascii//TRANSLIT)"


## Detecting pipe
#pipe_sep=";;"
#
#pipe="$(echo $input | sed 's/|//g' | sed "s/[ ]*$pipe_sep[ ]*/|/" | cut -sd"|" -f1)"
#if [ $(echo $pipe | wc -w) -gt 0 ]; then
#	piping=("--pipe" "$pipe")
#	echo "pipe detected: ${piping[@]}"
#	input=$(echo $input | sed "s/$pipe_sep/|/" | sed "s/^.*|//")
#fi


# Retrieving the name of available tools by the contents of tool_name variable
tools="$(grep ^tool_name= tools/* | sed -E 's/^[^"]*"([^"]*)"/\1/' | grep -v Dummy | awk -v d="\\\\n" '{s=(NR==1?s:s d)$0}END{print s}')"


# Using dynamic menu that places the most used options on top
action=$(core/custom_menu.sh --menu "$tools" --path "$0" -l "$lastAction" --prompt "$(echo $input | fold -sw 60)..." --pipe "$input")


pipe_sep=";;"
input=$(echo $input | sed "s/$pipe_sep/|/" | sed "s/^.*|//")


# Fetching the tool file to run
script="$(grep ^tool_name=\"$action\" tools/* | cut -d":" -f 1)"

# If not found, restart tool
if [ -z "$script" ]; then
	#./text.sh
	exit 0
fi



# Running selected tool, when found
$script --input "$input"

