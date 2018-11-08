#!/bin/bash

#####INIT VARS#####
SCRIPT=$(readlink -f $0)
ROOT=$(dirname $SCRIPT)

SERVER=$ROOT/minecraft
BACKUP=$ROOT/backup
LOGS=$ROOT/logs
HTTPD=$ROOT/httpd

LOGFILE=$LOGS/$(date +%Y-%m-%d).log

MAPCRAFTER=$ROOT/mapcrafter
REGIONFIXER=$ROOT/region-fixer

COMMAND="java -Xmx3072M -jar minecraft_server.jar nogui"
#####ENDINIT VARS#####

#####METHODS#####
function log() {
	echo "$(date +%T) - $@" >> $LOGFILE
}

function startServer() {

	isScreenRunning
	if [ $? == 0 ]
	then
		log "Starting MC-Server..."
		screen -dmS minecraft
		sleep 0.5
		screen -S minecraft -p 0 -X stuff "cd $SERVER"`echo -ne '\015'`
		sleep 0.5
		screen -S minecraft -p 0 -X stuff "ulimit -c unlimited"`echo -ne '\015'`
		sleep 0.5
		screen -S minecraft -p 0 -X stuff "$COMMAND"`echo -ne '\015'`
		log "MC-Server started."
	else
		log "Server already running!"
	fi
}

function stopServer() {

	isScreenRunning
	if [ $? == 1 ]
	then
		log "Stopping MC-Server..."
		screen -S minecraft -p 0 -X stuff "stop"`echo -ne '\015'`
		while [ _$(pgrep -f "$COMMAND") != "_" ]; do
			:
		done
		screen -S minecraft -X quit
		log "MC-Server stopped."
	else
		log "MC-Server not running!"
	fi
}

function isScreenRunning() {

	if [ "_$(screen -list | grep minecraft)" != "_" ]
	then
		return 1
	else
		return 0
	fi
}

function writeMessageToServer() {

	PARAMS=$@

	isScreenRunning
	if [ $? == 1 ]
	then
		screen -S minecraft -p 0 -X stuff "$PARAMS"`echo -ne '\015'`
	else
		log "MC-Server not running! Message: '$PARAMS' not delivered."
	fi
}

function backup() {

	log "Starting backup with rsync..."
	writeMessageToServer save-off
	rsync --backup --backup-dir=`date +%Y-%m-%d` --exclude backup --exclude httpd --exclude region-fixer --exclude mapcrafter -a $ROOT $BACKUP >> $LOGFILE
	writeMessageToServer save-on
	log "Backup done."
}

function map() {

	cd $MAPCRAFTER/src

	log "Starting mapping..."
	writeMessageToServer save-off
	./mapcrafter -c config-render -j 4 >> $LOGFILE
	writeMessageToServer save-on
	log "Mapping done."
}

function update() {

	log "Installing/Updating 'region-fixer' and 'mapcrafter'."

	if [ -d $REGIONFIXER ]
	then
		cd $REGIONFIXER
		git pull https://github.com/Fenixin/Minecraft-Region-Fixer.git >> $LOGFILE

		log "'region-fixer' updated!"
	else
		cd $ROOT
		git clone https://github.com/Fenixin/Minecraft-Region-Fixer.git >> $LOGFILE

		mv Minecraft-Region-Fixer region-fixer
		
		log "'region-fixer' installed!"
	fi

	if [ -d $MAPCRAFTER ]
	then
		cd $MAPCRAFTER
		git pull https://github.com/m0r13/mapcrafter.git >> $LOGFILE

		cmake . >> $LOGFILE
		make >> $LOGFILE

		log "'mapcrafter' updated!"
	else
		cd $ROOT
		git clone https://github.com/m0r13/mapcrafter.git >> $LOGFILE

		cd $MAPCRAFTER

		cmake . >> $LOGFILE
		make >> $LOGFILE

		log "'mapcrafter' installed!"
	fi
}

function init() {
	mkdir -p $SERVER $BACKUP $LOGS $HTTPD

	echo -e "root:\t\t$ROOT\nserver:\t\t$SERVER\nbackup:\t\t$BACKUP\nlogs:\t\t$LOGS\nwebserver:\t$HTTPD\nmapcrafter:\t$MAPCRAFTER\nregionfixer:\t$REGIONFIXER"

	update	
}
#####ENDINIT METHODS#####

#####SCRIPT#####
CHOICE=$1

case _$CHOICE in
	_start)
		startServer
		;;
	_stop)
		stopServer
		;;
	_restart)
		stopServer
		startServer
		;;
	_write)
		writeMessageToServer ${@:2}
		;;
	_backup)
		backup
		;;
	_map)
		map
		;;
	_update)
		update
		;;
	_init)
		init
		;;
	_maintenance)
		stopServer
		backup
		update
		map
		startServer
		;;
	*)
		echo "Usage: $0 [start|restart|stop|write|backup|map|update|init|maintenance]"
		log "Didn't run script! Wrong or no parameter was given."
		exit 1
		;;
esac
#####ENDSCRIPT#####
