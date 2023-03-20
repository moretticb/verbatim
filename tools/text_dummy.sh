#!/bin/bash

# text_dummy.sh
# This is a template file for new tools. It must receive at least the argument
# for --input parameter (or -i), which will be set to $input variable. Such
# variable can be used on implementation. If your tool needs more parameters,
# then the logic from the main program must be adapted.
#
# When you are finished implementing the new tool, as long as it is placed
# within tools folder and $tool_name variable is properly set, it should be
# ready to use.


# This is the name that will appear on the main menu
tool_name="Dummy"

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




# Implementation goes BELOW this line.


# Doing absolutely nothing with the input
output="$input"


# Implementation goes ABOVE this line.




# Chaining back to the next tool. Edit this only if necessary
./text.sh --input "$output" --last-action "$tool_name"
