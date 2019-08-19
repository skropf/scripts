#!/bin/bash

IFS=$'\n';
LIST=$(find . -type f)

for file in $LIST
do
        extension=$(echo $file | cut -d'.' -f 3)
	name=${file:0:${#file}-$((13 + ${#extension}))}

        #echo -e $name'.'$extension
	mv $file $name'.'$extension
done
