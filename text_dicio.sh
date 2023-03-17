#!/bin/bash

path="/opt/homebrew/bin/"

echo "Pesquisa em dicionario: $1"
line=$(links -dump https://www.dicio.com.br/$(echo "$1" | awk '{print tolower($0)}')/ | tail --lines=+11 | $path/choose -n 10)

if [ $? = 1 ]; then
	exit 1;
fi

$HOME/scripts/text.sh "-" "$line" "$2"
