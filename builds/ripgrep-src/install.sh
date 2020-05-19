#!/bin/bash

# rust is required (use rustup)
if rust_loc=$(type -p "cargo") || ! [ -z "$rust_loc" ];then
  export CARGO_HOME=$(pwd)
  export PATH=$PATH:$CARGO_HOME/bin

  git clone https://github.com/BurntSushi/ripgrep
  cd ripgrep
  cargo build --release
  cp ./target/release/rg $HOME/devel/usr/bin
  cd $CARGO_HOME &&
    rm -rf ./ripgrep &&
    rm -rf ./registry &&
    rm -r ./.package-cache

else
  echo "Rust is required. Please install with rustup."
fi
