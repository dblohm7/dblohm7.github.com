#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install rbenv
  brew install ruby-build
  rbenv install 1.9.3-p551
  rbenv local 1.9.3-p551
  rbenv rehash
  gem install bundler
  rbenv rehash
  bundle install
fi
