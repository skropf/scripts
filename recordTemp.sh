#!/bin/bash

recordTemperature() {
	while [ 1 ]
	do
		TEMP="/opt/vc/bin/vcgencmd measure_temp"
		$TEMP >> temp.txt
		sleep 2s
	done
}

recordTemperature &
