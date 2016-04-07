#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install rbenv
  brew install ruby-build
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  # For dependencies
  sudo apt-get install rbenv ruby-build
  # Let's pull the most recent versions
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  export PATH="$HOME/.rbenv/bin:$PATH"
fi
eval "$(rbenv init -)"
# Get the newest available ruby 1.9.3 interpreter
PATCHNUM=$(rbenv install -l 2>&1 | sed -rn 's/^  2\.1\.([[:digit:]]+)$/\1/p' | sort -g | tail -n 1)
rbenv install 2.1.${PATCHNUM}
rbenv local 2.1.${PATCHNUM}
rbenv rehash
gem install bundler
rbenv rehash
bundle install
