#!/bin/bash

cd textures-mods/
IFS=$'\n'
FOLDER=$1
PNGFILES=$(find $FOLDER -name "*.png")
JARFILES=$(find $FOLDER -name "*.jar")

for FILE in $JARFILES
do
    echo $FILE
    
    if [ $(jar tf "$FILE" | grep 'png$' | wc -l) -ge 1 ]; then
	unzip -o "$FILE" "*.png"
    fi
done
