#!/bin/bash

tool_name="Dictionary"

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



echo "Pesquisa em dicionario: $input"
line=$(links -dump https://www.dicio.com.br/$(echo "$input" | awk '{print tolower($0)}')/ | tail --lines=+11 | choose -n 10)

if [ $? = 1 ]; then
	exit 1;
fi

./text.sh --input "$line" --last-action "$tool_name"
