#!/bin/bash

PICS=~/Downloads/pics
COUNTER=1

cd $PICS

for file in *
do
	if [ -f IMG_$COUNTER.JPG ]; then
		echo "Nothing done: 'IMG_$COUNTER.JPG'"
	else
		echo "Moved '$file'"
		mv "$file" IMG_$COUNTER.JPG
	fi
	COUNTER=$((COUNTER + 1))
done
