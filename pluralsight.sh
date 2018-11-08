#!/bin/bash

while IFS='' read -r line || [[ -n "$line" ]]; do

	IFS=';' read -ra ADDR <<< "$line"
	
	name=${ADDR[0]}
	link=${ADDR[1]}
	
	echo "$name - $link"

	mkdir "$name"
	cd "$name"

	youtube-dl $link --sleep-interval 30 --max-sleep-interval 60 -u <user> -p <password>
	
	IFS=''
	cd ..

done < "$1"



