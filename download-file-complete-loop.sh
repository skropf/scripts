#!/bin/bash

while [[ $(cat header | grep Content-Length: | awk '{print $2}') != $(ls -l | grep <filename> | awk '{print $5}') ]]
do
	if [[ $(ps ax | grep curl | wc -l) < 2 ]]
	then
		curl -L -O -C - <link>
	fi
done
