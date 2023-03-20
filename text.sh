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
	input=$(echo -e "0line0\n$inputLine" | sed -E "s/[[:space:][:punct:]]+/\n/g" | choose -m)
	if [ "$input" = "0line0" ]; then
		input=$(echo "$inputLine" |  sed -E "s/[ ]+/ /g" | sed "s/[\"\']//g" | core/dialog_input.sh "edit line")
	fi
elif [ -n "$inputLine" ]; then
	input=$inputLine
else
	input=$(echo "Input something" | choose -n -1 -m)
fi

if [ -z "$input" ]; then
	exit 0
fi



# Avoiding problems due to weird charset encoding
input=$(echo "$input" | iconv -f utf8 -t ascii//TRANSLIT)


# Retrieving the name of available tools by the contents of tool_name variable
tools="$(grep ^tool_name= tools/* | sed -E 's/^[^"]*"([^"]*)"/\1/' | grep -v Dummy | awk -v d="\\\\n" '{s=(NR==1?s:s d)$0}END{print s}')"


# Using dynamic menu that places the most used options on top
action=$(core/custom_menu.sh "$tools" "$0" "$lastAction")


# Fetching the tool file to run
script="$(grep ^tool_name=\"$action\" tools/* | cut -d":" -f 1)"

# If not found, restart tool
if [ -z "$script" ]; then
	./text.sh
	exit 0
fi



# Running selected tool, when found
$script --input "$input"

