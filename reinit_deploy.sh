#!/bin/bash

ORIGIN_URL=`git config --get remote.origin.url`
rm -rf _deploy
mkdir _deploy
cd _deploy
git init
git config user.name "Aaron Klotz"
git config user.email aklotz@mozilla.com
git remote add origin $ORIGIN_URL
cd ..

