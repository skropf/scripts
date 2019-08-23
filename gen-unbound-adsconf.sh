#!/bin/bash

SCRIPTDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)

download() {
	cd $SCRIPTDIR

	# create folder & go into it
	mkdir cache && cd cache

	# download full collection of lists
	curl -o all-lists "https://v.firebog.net/hosts/lists.php?type=all"

	# create download dir + cd into it
	mkdir lists && cd lists

	# download all lists
	cat ../all-lists | xargs -n1 curl -O
}

extract-domains() {
	# go into folder where textfiles with domains are
	cd $SCRIPTDIR/cache
	mkdir domains

	# find all domains using regex (some files won't work)
	cat lists/* | grep -P "(?=^.{4,253}$)(^(?:[a-zA-Z0-9](?:(?:[a-zA-Z0-9\-]){0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$)" > domains/domains.txt

	# custom commands for getting rest of domains
	cut -d' ' -f2 lists/adservers.txt | tail -n +9 > domains/adservers.txt
	cut -d$'\t' -f2 lists/ad_servers.txt | tail -n +11 | head -n -1 > domains/ad_servers.txt
	cut -d$'\t' -f2 lists/emd.txt | tail -n +10 | head -n -1 > domains/emd.txt
	cut -d$'\t' -f2 lists/exp.txt | tail -n +10 | head -n -1 > domains/exp.txt
	cut -d$'\t' -f2 lists/grm.txt | tail -n +10 | head -n -1 > domains/grm.txt
	cut -d' ' -f2 lists/hosts | tail -n +9 > domains/hosts
	cut -d$'\t' -f2 lists/hosts0.txt | tail -n +35 > domains/hosts0.txt
	cut -d' ' -f3 lists/hosts.txt | tail -n +7 > domains/hosts.txt
	cut -d' ' -f2 lists/minimalhosts | tail -n +6 > domains/minimalhosts
	cut -d' ' -f1 lists/notrack-malware.txt | tail -n +10 > domains/notrack-malware.txt
	cut -d$'\t' -f2 lists/psh.txt | tail -n +10 | head -n -1 > domains/psh.txt
	cut -d' ' -f2 lists/spy.txt | tail -n +7 > domains/spy.txt

	# delete empty files
	find domains/ -empty -type f -delete
}

assemble-and-sort() {
	# change dir
	cd $SCRIPTDIR/cache
	
	# assemble all domains in one file
	cat domains/* > all-domains.txt

	# get rid of redundant domains
	cat all-domains.txt | sort | uniq > domains.txt

	# clean up domain names
	cat domains.txt | sed 's/ //g' | sed 's///g' | sed '/^[[:space:]]*$/d' > domains-cleaned.txt
}

convert-for-unbound() {
	# change dir
	cd $SCRIPTDIR

	# convert to unbound format
	awk '{print "local-zone: \"", $1, "\" redirect\nlocal-data: \"", $1, "A 0.0.0.0\""}' cache/domains-cleaned.txt | sed 's/: " /: "/g' | sed 's/ " /" /g' > ads.conf
}

cleanup() {
	# change dir
	cd $SCRIPTDIR

	# remove cache files
	rm -r cache/
}


# main routine
download
extract-domains
assemble-and-sort
convert-for-unbound
cleanup
