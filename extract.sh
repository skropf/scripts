#!/bin/bash

FILES=$(find protein-structures/ -name *.gz)

i=1
all=$(echo "$FILES" | wc -w)
for file in $FILES
do
    if [ $(($i % 100)) -eq 0 ]; then echo $i/$all; fi
    arr=(${file//// })
    name=${arr[1]}
    arr=(${name//./ })
    codename=${arr[0]}
    gunzip -k -c $file > protein-structures-textfiles/$codename.cif
    i=$((i+1))
done
