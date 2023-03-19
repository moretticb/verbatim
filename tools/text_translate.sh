#!/bin/bash

lang_menu="en"
lang_menu="$lang_menu\npt"
lang_menu="$lang_menu\nit"
lang_menu="$lang_menu\nnl"
lang_menu="$lang_menu\npt-en"
lang_menu="$lang_menu\nen-pt"
lang_menu="$lang_menu\npt-it"
lang_menu="$lang_menu\nit-pt"
lang_menu="$lang_menu\nit-en"
lang_menu="$lang_menu\nen-it"
lang_menu="$lang_menu\nnl-en"
lang_menu="$lang_menu\nen-nl"

lang=$(core/custom_menu.sh "$lang_menu" "$0" "$lastAction")

if [ $? = 1 ]; then
	exit 1;
fi

from="$(echo $lang | cut -d"-" -f 1)"
to="$(echo $lang | cut -d"-" -f 2)"

if [ "$from" = "$to" ]; then
	from="auto"
fi


user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0"
header="Accept: text/json"
#api_url="http://translate.googleapis.com/translate_a/single?client=gtx&sl=$from&tl=$to&dt=at&q=$1"
api_url="http://translate.googleapis.com/translate_a/single"
line=$(\
	curl\
	--header "${header}"\
	--user-agent "${user_agent}"\
	--data-urlencode "client=gtx"\
	--data-urlencode "sl=$from"\
	--data-urlencode "tl=$to"\
	--data-urlencode "dt=at"\
	--data-urlencode "q=$1"\
	 -sL "${api_url}" | jq .[5][0][2][0][0] | choose -m)


if [ "$?" = 1 ]; then
	exit 1;
fi

./text.sh "-" "$line" "$2"
