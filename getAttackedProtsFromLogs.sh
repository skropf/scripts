#!/bin/bash

cat /var/log/everything.log* | grep "UFW BLOCK" | grep -o -e "SPT=[0-9]*" -e "DPT=[0-9]*" > attacked-ports.txt
#cat attackers-ips.txt | sort | uniq > uniq-attackers-ips.txt
#cat uniq-attackers-ips.txt | xargs -i whois {} | grep country: | cut -d' ' -f9 | tr '[:lower:]' '[:upper:]' > uniq-attackers-countries-all.txt
#cat uniq-attackers-countries-all.txt | sort | uniq -c > attackers-countrylist.txt
