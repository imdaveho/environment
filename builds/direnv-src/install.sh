#!/bin/bash

if go_loc=$(type -p "go") || ! [ -z "$go_loc" ];then
  export GOPATH=$(pwd)/.go_modules
  export PATH=$PATH:$GOPATH/bin
  go get -u github.com/cpuguy83/go-md2man/v2
  mkdir -p ./target/release
  git clone https://github.com/direnv/direnv
  cd direnv
  make install PREFIX=$HOME/devel/usr/src/direnv-src/target/release

  # move binary to ~/devel/usr/bin
  cd $HOME/devel/usr/src/direnv-src
  cp ./target/release/bin/direnv $HOME/devel/usr/bin/ && \

  # cleanup
    rm -rf $HOME/devel/usr/src/direnv-src/target && \
    rm -rf $HOME/devel/usr/src/direnv-src/direnv && \
    go clean -modcache && \
    rm -rf $HOME/devel/usr/src/direnv-src/.go_modules

  export GOPATH=$HOME/devel/golang/.go_modules
else
  echo "Go >= 1.9 is required. Please install with asdf."
fi
