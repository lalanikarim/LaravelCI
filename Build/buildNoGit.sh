#!/bin/sh
GIT_SRC=$HOME/src
GIT_DEST=/app/publish
BUILD_STATUS=/app/status
STATUS_STARTED=$BUILD_STATUS/started
STATUS_READY=$BUILD_STATUS/ready
STATUS_LIVE=$BUILD_STATUS/live
STATUS_DEPLOYED=$BUILD_STATUS/deployed

mkdir -p $GIT_DEST/public $BUILD_STATUS

syncfiles() {
  echo "Syncing files..."
  rsync -a --exclude='.git' . $GIT_DEST 
  echo "Files synced..."
  if [[ ! -z "${POST_SYNC_COMMANDS}" ]]
  then
    echo "Running Post Sync Commands..."
    $POST_SYNC_COMMANDS
  else
    echo "No Post Sync Commands..."
  fi
}

cd $GIT_SRC

syncfiles
while true
do
  syncfiles
  echo "sleeping..."
  sleep $SLEEP_DURATION
done
