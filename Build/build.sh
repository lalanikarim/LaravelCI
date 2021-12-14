#!/bin/sh
GIT_SRC=$HOME/src
GIT_DEST=/app/publish
BUILD_STATUS=/app/status
STATUS_STARTED=$BUILD_STATUS/started
STATUS_READY=$BUILD_STATUS/ready
STATUS_LIVE=$BUILD_STATUS/live
STATUS_DEPLOYED=$BUILD_STATUS/deployed

mkdir -p $GIT_DEST/public $BUILD_STATUS
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/ssh-config/known_hosts -i /ssh-config/id_file"
runbuild() {
  if [[ ! -z "${RESET_REV_COUNT}" ]]
  then
    git reset HEAD~$RESET_REV_COUNT
    git clean -fd
    git checkout -- .
  fi
  git pull origin $GIT_BRANCH && touch $STATUS_STARTED
  if [ ! -e $STATUS_DEPLOYED ] || [ $(cat $STATUS_DEPLOYED) != $(git rev-parse HEAD) ]
  then
    echo "Starting build..."
    if [ -e "composer.json" ]
    then 
      echo "Running Composer..."
      [ $# == 1 ] && $1 && composer dumpautoload
      composer.phar install
      composer.phar update
      if [[ ! -z "${POST_COMPOSER_COMMANDS}" ]]
      then
        echo "Running Post Composer Commands..."
        $POST_COMPOSER_COMMANDS
      else
        echo "No Post Composer Commands..."
      fi
    else
      echo "Skipping Composer..."
    fi
    if [ -e "package.json" ] 
    then
      echo "Running NPM..."
      npm install
      #npm update
      npm run prod
    else
      echo "Skipping NPM..."
    fi
  else
    echo "Skipping build..."
  fi
}

syncfiles() {
  echo "Syncing files..."
  rsync -a --exclude='.git' . $GIT_DEST && \
    echo -n $(git rev-parse HEAD) > $STATUS_DEPLOYED
  echo "Files synced..."
  if [[ ! -z "${POST_SYNC_COMMANDS}" ]]
  then
    echo "Running Post Sync Commands..."
    $POST_SYNC_COMMANDS
  else
    echo "No Post Sync Commands..."
  fi
  touch $STATUS_READY $STATUS_LIVE
}

if [ ! -d "$GIT_SRC" ] 
then
  echo "Cloning..."
  git clone $GIT_URL $GIT_SRC
else
  echo "Existing clone..."
fi
cd $GIT_SRC


git fetch origin
#if [ `git rev-parse --verify $GIT_BRANCH` ] 
#then
#  echo "Remote branch exists locally..."
#  git checkout $GIT_BRANCH
#else
#  echo "Checking out remote branch..."
#  git checkout -b $GIT_BRANCH origin/$GIT_BRANCH
#fi

echo "Switching to remote branch..."
git switch $GIT_BRANCH

runbuild
syncfiles
while true
do
  git fetch origin
  if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]
  then
    echo "Remote updated. Processing..."
    runbuild true
  else
    echo "Remote not updated. Skipping..."
  fi
  syncfiles
  echo "sleeping..."
  sleep $SLEEP_DURATION
done
