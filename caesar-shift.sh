#!/bin/bash

###convert int to char
chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}
###convert char to int
ord() {
  LC_CTYPE=C printf '%d' "'$1"
}

###read input+pattern
echo "Input hint: "
read HINT
echo "Input caesar-shift pattern: "
read PATTERN

PATTERN=($PATTERN) #convert string to array
RESULT=""
RESULT_TWO=""
PATTERN_INDEX=0
HINT_ARRAY=($(echo $HINT | grep -o .)) #convert string to char array
for CHAR in ${HINT_ARRAY[@]} #loop through HINT char by char
do
  if [ -z "${PATTERN[$PATTERN_INDEX]}" ]; then PATTERN_INDEX=0; fi #if pattern reached end - start anew

  PATTERN_INT=${PATTERN[$PATTERN_INDEX]} #get elem from pattern
  CHAR_INT=$(ord $CHAR) #convert char to ASCII-int
  RESULT=$RESULT""$(chr $(($CHAR_INT+$PATTERN_INT))) #convert back to char and add to result
  RESULT_TWO=$RESULT_TWO""$CHAR_INT" "
  PATTERN_INDEX=$(($PATTERN_INDEX+1)) #inc pattern index
done

echo "Result: "$RESULT #print result
echo "Result2: "$RESULT_TWO
