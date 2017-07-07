#!/bin/bash

#find . -type d -exec mkdir -p ../music_test/{} \;

IFS=$'\n';
LIST=$(find youtube-dl -type f)

for file in $LIST
do
	name=${file:0:${#file}}
	extension=$(echo $name | cut -d'.' -f 2)
	name=$(echo $name | cut -d'.' -f 1)
	name=${name:0:${#name}-12}
	
	echo -e $name'.'$extension
	ffmpeg -i $file mp3/$name.mp3
done
