#! /bin/bash

ROOT_UID="0"

#Check if run as root
if [ "$UID" -ne "$ROOT_UID" ] ; then
	echo "You must be root to do that!"
	exit 1
fi

echo -e 'Killing off old instances...\n'
killall dhclient
killall wpa_supplicant

echo -e 'Connecting to WiFi...\n'
ifconfig wlp4s0 down
wpa_supplicant -Dnl80211 -iwlp4s0 -cconfig-viren &
echo -e 'Configuring IP-Address...\n\n'
dhclient wlp4s0
echo -e 'Connection established\n'
