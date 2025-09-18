#!/bin/sh

CHAR="'"

[ "$(echo "$1" | cut -c -1)" = $CHAR ] || exit 0

cat /tmp/text_hist.txt | choose -o "$(echo "$1" | cut -c 2-)"
