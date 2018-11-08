#!/bin/bash


IFS=$'\n';
LIST=$(find . -name '*MOV')

for file in $LIST
do
	name=${file%.*}
	echo -e $name
	if [ ! -f $name.MP4 ]
	then
		ffmpeg -i $file -c:v libx264 -c:a aac $name.MP4
	fi
done
