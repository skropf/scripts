#!/bin/bash

IFS='\n'

raw_data=$(cat 1Z11.cif | grep ATOM)


echo $raw_data | tr -s ' ' | cut -d' ' -f3 > atoms

echo $raw_data | tr -s ' ' | cut -d' ' -f11 > x-data
echo $raw_data | tr -s ' ' | cut -d' ' -f12 > y-data
echo $raw_data | tr -s ' ' | cut -d' ' -f13 > z-data
