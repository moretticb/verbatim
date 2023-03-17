#!/bin/bash

echo "Pesquisa em dicionario: $1"
line=$(links -dump https://www.dicio.com.br/$(echo "$1" | awk '{print tolower($0)}')/ | tail --lines=+11 | choose -n 10)

if [ $? = 1 ]; then
	exit 1;
fi

./text.sh "-" "$line" "$2"
