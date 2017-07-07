#!/bin/bash

cd "$1"

FILES=$(find . -name '*.mp4')

DURATION=0
IFS=$'\n'

for FILE in $FILES
do
	DUR=$(ffprobe -i "$FILE" -show_entries format=duration -v quiet -of csv="p=0")
#	H=$(echo "$DUR/60/60" | bc)
#	M=$(echo "($DUR-($H*60*60))/60" | bc)
#	S=$(echo "$DUR-($H*60*60)-($M*60)" | bc)
#	echo $(basename "$FILE")-$H:$M:$S
	DURATION=$(echo "$DURATION + $DUR" | bc)
done
#echo $DURATION

HOURS=$(echo "$DURATION/60/60" | bc)
MINUTES=$(echo "($DURATION-($HOURS*60*60))/60" | bc)
SEC=$(echo "$DURATION-($HOURS*60*60)-($MINUTES*60)" | bc)

echo $HOURS:$MINUTES:$SEC
