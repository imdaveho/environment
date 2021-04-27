#!/bin/bash

# touch .tool-versions
# echo "12.22.1" >> .tool-versions

mkdir -p $HOME/devel/usr/build/ferdi-git

# install dependencies for the resulting .deb
sudo apt install -y libnotify4 libappindicator3-1 libsecret-1-0

# nodejs is required (use asdf)
if node_loc=$(type -p "node") || ! [ -z  "$node_loc" ];then
  # Fetch ferdi build dependencies
  git clone https://github.com/getferdi/ferdi.git
  cd ferdi
  git submodule update --init --recursive
  npx lerna bootstrap
  npm run rebuild
  
  # Package recipes
  cd recipes
  npm install && npm run package
  cd ..

  # Build ferdi
  npm run build

  # Clean Up
  cp ./out/*.deb $HOME/devel/usr/build/ferdi-git
  cd .. && rm -rf ferdi
else
  echo "NodeJS is required. Please install with asdf."
fi
