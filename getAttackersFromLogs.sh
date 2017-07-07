#!/bin/bash

cat /var/log/everything.log* | grep "UFW BLOCK" | cut -d' ' -f11 | cut -d'=' -f2 | sort > attackers-ips.txt
cat attackers-ips.txt | sort | uniq > uniq-attackers-ips.txt
cat uniq-attackers-ips.txt | xargs -i whois {} | grep country: | cut -d' ' -f9 | tr '[:lower:]' '[:upper:]' > uniq-attackers-countries-all.txt
cat uniq-attackers-countries-all.txt | sort | uniq -c > attackers-countrylist.txt
