#!/bin/bash

# go >= 1.9 is required (use asdf)
export GOPATH=$(pwd)
export PATH=$PATH:$GOPATH/bin
mkdir -p ./target/release
git clone https://github.com/direnv/direnv
cd direnv
make install DESTDIR=$HOME/devel/usr/src/direnv-src/target/release

# move binary to ~/devel/usr/bin
cd $HOME/devel/usr/src/direnv-src
cp ./target/release/bin/direnv $HOME/devel/usr/bin/ && \

# cleanup
  rm -rf $HOME/devel/usr/src/direnv-src/target && \
  rm -rf $HOME/devel/usr/src/direnv-src/direnv
