#!/bin/sh

USER="backup"
HOST=<destination ip/hostname>
PRIVATE_KEY="id_ed25519"
SSH="ssh -i ~/.ssh/$PRIVATE_KEY"

DEST="/mnt/backup"
SRC="/mnt/HD"

NEW_FOLDER="$(date +%F_%H-%M-%S)"

rsync -e "$SSH" --archive --human-readable --progress --link-dest "$USER@$HOST:$DEST/current" "$SRC" "$USER@$HOST:$DEST/incomplete/"

$SSH $USER@$HOST "mv $DEST/incomplete $DEST/$NEW_FOLDER"
$SSH $USER@$HOST "rm -f $DEST/current"
$SSH $USER@$HOST "ln -s $DEST/$NEW_FOLDER $DEST/current"
