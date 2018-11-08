#!/bin/bash

if [[ _$1 == _a* ]]
then
	if [ _$2 == '_all' ]
	then
		f5fpc -s -t vpn.univie.ac.at:8443 -u $1
	else
		f5fpc -s -t vpn.univie.ac.at -u $1
	fi
fi

if [ _$1 == '_kill' ]
then
	f5fpc -o
fi

if [ _$1 == '_info' ]
then
	f5fpc --info
fi
