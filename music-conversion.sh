#!/bin/bash

#find . -type d -exec mkdir -p ../music_test/{} \;

IFS=$'\n';
LIST=$(find .)

for file in $LIST
do
	name=${file%-*}
	#mv $name.mp3 $name.aac
	echo -e $name
	ffmpeg -i $file -b:a 192k converted/$name.mp3
done
