#!/bin/bash

if go_loc=$(type -p "go") || ! [ -z "$go_loc" ];then
  export GOPATH=$(pwd)/.gomodules
  export PATH=$PATH:$GOPATH/bin
  # TODO: go get won't work without initializing a module now
  go mod init builds.pseudoken/direnv
  # below is due to https://github.com/direnv/direnv/issues/761
  go get -u github.com/cpuguy83/go-md2man/v2
  mkdir -p ./target/release
  git clone https://github.com/direnv/direnv
  cd direnv
  make install PREFIX=$HOME/Develop/usr/ext/source/direnv-src/target/release

  # move binary to ~/Develop/usr/bin
  cd $HOME/Develop/usr/ext/source/direnv-src
  cp ./target/release/bin/direnv $HOME/Develop/usr/bin/ && \

  # cleanup
    rm -rf $HOME/Develop/usr/ext/source/direnv-src/target && \
    rm -rf $HOME/Develop/usr/ext/source/direnv-src/direnv && \
    go clean -modcache && \
    rm -rf $HOME/Develop/usr/ext/source/direnv-src/.go_modules

  export GOPATH=$HOME/devel/golang/.go_modules
else
  echo "Go >= 1.9 is required. Please install with asdf."
fi
