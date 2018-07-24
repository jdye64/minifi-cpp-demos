#!/bin/bash

# Global variables
REPO_NAME=minifi-cpp-demos
GIT_DEMO_REPO=https://github.com/jdye64/$REPO_NAME.git
DEMO_HOME=$PWD/$REPO_NAME
MINIFI_HOME=/opt/nifi-minifi-cpp-0.6.0

# Ensuring the required programs are installed
command -v git >/dev/null 2>&1 || { echo >&2 "I require git but it's not installed. Aborting."; exit 1; }

# Pull down the repo if it hasn't already been cloned
CUR_DIR_NAME="$(echo "$PWD" | rev | cut -d'/' -f1 | rev)"
echo "Current Directory Name: $CUR_DIR_NAME"
if [ "$CUR_DIR_NAME" != "$REPO_NAME" ] && [ ! -d "$PWD/$REPO_NAME" ]; then
  echo "The repo does not exist locally. Pulling it from Github now ...."
  git clone $GIT_DEMO_REPO
fi

echo "MiNiFi Home: $MINIFI_HOME"
echo "Git Repo: $GIT_DEMO_REPO"
echo "Demo Repo: $REPO_NAME"
echo "Demo Home Directory: $DEMO_HOME"

echo "Listing Demos that are available to be installed on a MiNiFi C++ environment"
# List all of the Demos that are available
find $PWD/Demos/* -prune -type d | while IFS= read -r d; do
	demo_name="$(echo "$d" | rev | cut -d'/' -f1 | rev)"
	echo "Demo: -> $demo_name"
done

# Listen for the demo that you want to install
read -p "Which Demo do you want to install?: " demoName
echo "Deploying Demo: '$demoName' to '$MINIFI_HOME'"

# Ensure that the MINIFI_HOME exists
if [ ! -d "$MINIFI_HOME" ]; then
  echo "The MiNiFi Home directory of: $MINIFI_HOME does not exist on this machine"; exit 1;
fi

# Copy the configurations to MINIFI_HOME
cp $PWD/Demos/$demoName/* $MINIFI_HOME/conf/.

echo "'$demoName' deployed to: '$MINIFI_HOME'"
$MINIFI_HOME/bin/minifi.sh restart