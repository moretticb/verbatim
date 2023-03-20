#!/bin/bash

tool_name="Synonym"

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


echo "Pesquisa em sinonimos: $input"
line=$(links -dump https://www.sinonimos.com.br/$input/ | sed -E "s/^   ([^0-9A-Z][^,]*)$//g" | sed -E "s/^   [A-Z].*[^:.]$//g" | sed -E "s/^   ([A-Z])/\1/g" | grep -v ^$ | choose)

if [ $? = 1 ]; then
	exit 1;
fi

./text.sh --input "$line" --last-action "$tool_name"
