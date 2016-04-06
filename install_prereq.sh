#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install rbenv
  brew install ruby-build
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  sudo apt-get install rbenv ruby-build
fi
eval "$(rbenv init -)"
# Get the newest available ruby 1.9.3 interpreter
PATCHNUM=$(rbenv install -l 2>&1 | sed -rn 's/^  1\.9\.3-p([[:digit:]]+)$/\1/p' | sort -g | tail -n 1)
rbenv install 1.9.3-p${PATCHNUM}
rbenv local 1.9.3-p${PATCHNUM}
rbenv rehash
gem install bundler
rbenv rehash
bundle install
