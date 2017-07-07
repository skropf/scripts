#!/bin/bash

cd "$1"
LIST=$(ls *.CR2)
all=$(ls *.CR2 | wc -l)
i=1

for img in $LIST
do
	IFS="."
	set $img
	name=$1
	echo "Processing $name ($i of $all)"
	convert $name.CR2 -quality 50 $name.JPG
	#convert -thumbnail 250 $name.JPG ../thumbs/$name.JPG
	i=$(( i + 1 ))
done
