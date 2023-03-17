#!/bin/bash

read input

# prompt "Question" "Default value"
function prompt() {
  osascript <<EOT
    tell app "System Events"
      text returned of (display dialog "$1" default answer "$2" buttons {"OK","Cancel"} default button 1 with title "$(basename $0)")
    end tell
EOT
}

output="$(prompt "$1" "$input")"

if [ "$output" = "" ]; then
	exit 1
fi

echo "$output"
exit 0
