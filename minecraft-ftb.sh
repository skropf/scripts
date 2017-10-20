#!/bin/bash

#####INIT VARS#####
SCRIPT=$(readlink -f $0)
ROOT=$(dirname $SCRIPT)

echo $SCRIPT
echo $ROOT

SERVER=$ROOT/minecraft
BACKUP=$ROOT/backup
LOGS=$SERVER/logs
HTTPD=$ROOT/httpd

echo $SERVER
echo $LOGS

LOGFILE=$LOGS/$(date +%Y-%m-%d).log

MAPCRAFTER=$ROOT/mapcrafter
REGIONFIXER=$ROOT/region-fixer

NAME="FeedTheBeast Infinity Evolved"
COMMAND="./ServerStart.sh"
#####ENDINIT VARS#####

#####METHODS#####
function log() {
	echo "$(date +%T) - $@" ### >> $LOGFILE
}

function startServer() {

	isRunning
	if [ $? == 0 ]
	then
		log "Starting MC-Server..."
		tmux new-session -d -s FTB
		tmux send-keys -t FTB -l "cd $SERVER"
		tmux send-keys -t FTB Enter
		tmux send-keys -t FTB -l "$COMMAND"
		tmux send-keys -t FTB Enter
		log "MC-Server started."
	else
		log "Server already running!"
	fi
}

function stopServer() {

	isRunning
	if [ $? == 1 ]
	then
		log "Stopping MC-Server..."
		tmux send-keys -t FTB -l stop
		tmux send-keys -t FTB Enter
		while [ _$(pgrep -f "$COMMAND") != "_" ]; do
			:
		done
		tmux send-keys -t FTB -l exit
		tmux send-keys -t FTB Enter
		log "MC-Server stopped."
	else
		log "MC-Server not running!"
	fi
}

function isRunning() {

	if [ "_$(tmux ls | grep FTB)" == "_" ]
	then
		return 0
	else
		return 1
	fi
}

function writeMessageToServer() {

	PARAMS=$@

	isRunning
	if [ $? == 1 ]
	then
		tmux send-keys -t FTB -l "/say $PARAMS"
		tmux send-keys -t FTB Enter
	else
		log "$NAME not running! Message: '$PARAMS' not delivered."
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
