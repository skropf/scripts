#!/bin/bash

#find . -type d -exec mkdir -p ../music_test/{} \;

IFS=$'\n';
LIST=$(find . -name *.mp3)

for file in $LIST
do
	name=${file:2:${#file}-6}
	#mv $name.mp3 $name.aac
	echo -e $name
	#ffmpeg -i $name.flac -strict -2 -n ../music_test/$name.aac
done
