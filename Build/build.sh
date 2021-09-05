#!/bin/sh
GIT_SRC=$HOME/src
GIT_DEST=/app/publish
mkdir -p $GIT_DEST/public
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/ssh-config/known_hosts -i /ssh-config/id_file"
runbuild() {
  git pull origin $GIT_BRANCH
  if [ -e "composer.json" ]
  then 
    echo "Running Composer..."
    [ $# == 1 ] && $1 && composer dumpautoload
    composer install
  else
    echo "Skipping Composer..."
  fi
  if [ -e "package.json" ] 
  then
    echo "Running NPM..."
    npm install
    npm run prod
  else
    echo "Skipping NPM..."
  fi
  rsync -a --exclude='.git' . $GIT_DEST
  #rsync --exclude='.git' . $GIT_DEST
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
if [ `git rev-parse --verify $GIT_BRANCH` ] 
then
  echo "Remote branch exists locally..."
  git checkout $GIT_BRANCH
else
  echo "Checking out remote branch..."
  git checkout -b $GIT_BRANCH origin/$GIT_BRANCH
fi
runbuild
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
  echo "sleeping..."
  sleep 10
done
