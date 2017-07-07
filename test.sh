#!/bin/bash

cd music/

find . -type d -exec mkdir -p ../music_compressed/{} \;

all=$(find . -type f -name *.flac | wc -l)
i=1

find . -type f -name '*.flac' -print0 | while IFS= read -r -d '' file
do
	IFS="."
	read -ra names <<< $file
	name=""
	length=${#names[@]}
	echo $length
	echo -n
	#for (( j=0; j<length-1; j++ ))
	#do
	#	name=$(( name + ${names[j]}))
	#done

	#echo "Processing $name ($i of $all)"
	i=$(( i + 1 ))
done
