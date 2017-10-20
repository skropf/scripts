#!/bin/bash
IFS=$'\n'

CODES=$(cat cmpd_res.idx | tail -n +5 | cut -d";" -f 1 | tr -d "\t" | sort)
DOWNLOADED=$(ls protein-structures/ | sed 's/.cif.gz$//')

all=$(echo "$DOWNLOADED" | wc -w)
i=1
for CODE in $DOWNLOADED
do
    echo "Removing $CODE from download list...($i/$all)"
    CODES=$(echo "${CODES[@]/$CODE}")
    i=$((i+1))
done

all=$(echo "$CODES" | wc -w)
i=1
for CODE in $CODES
do
    echo "Downloading $CODE...($i/$all)"
    curl -# "http://files.rcsb.org/download/$CODE.cif.gz" -o "protein-structures/$CODE.cif.gz"
    i=$((i+1))
done
