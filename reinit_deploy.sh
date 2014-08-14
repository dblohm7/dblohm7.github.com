#!/bin/bash

USER_NAME=`git config --get user.name`
USER_EMAIL=`git config --get user.email`
ORIGIN_URL=`git config --get remote.origin.url`
rm -rf _deploy
mkdir _deploy
cd _deploy
git init
git config user.name "$USER_NAME"
git config user.email "$USER_EMAIL"
git remote add origin $ORIGIN_URL
git pull origin master
cd ..

