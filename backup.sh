#!/bin/sh

# stop script if it's already running
# IMPORTANT NOTE: if other software uses rsync this will not be correct!
nr_procs="$(ps ax | grep rsync | wc -l)"
if [ "$nr_procs" -ne "1" ]
then
    echo "Backup already running. Stopping."
    exit
fi

echo "Starting backup."

USER="backup"
HOST=<destination ip/hostname>
PRIVATE_KEY="id_ed25519"
SSH="ssh -i ~/.ssh/$PRIVATE_KEY"

DEST="/mnt/backup"
# trailing slash is important here - otherwise it will create a subfolder
SRC="/mnt/HD/"

NEW_FOLDER="$(date +%F_%H-%M-%S)"

rsync -e "$SSH" --archive --human-readable --progress --link-dest "$USER@$HOST:$DEST/current" "$SRC" "$USER@$HOST:$DEST/incomplete/"

$SSH $USER@$HOST "mv $DEST/incomplete $DEST/$NEW_FOLDER"
$SSH $USER@$HOST "rm -f $DEST/current"
$SSH $USER@$HOST "ln -s $DEST/$NEW_FOLDER $DEST/current"
