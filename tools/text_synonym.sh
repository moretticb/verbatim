#!/bin/bash

echo "Pesquisa em sinonimos: $1"
line=$(links -dump https://www.sinonimos.com.br/$1/ | sed -E "s/^   ([^0-9A-Z][^,]*)$//g" | sed -E "s/^   [A-Z].*[^:.]$//g" | sed -E "s/^   ([A-Z])/\1/g" | grep -v ^$ | choose)

if [ $? = 1 ]; then
	exit 1;
fi

./text.sh "-" "$line" "$2"
