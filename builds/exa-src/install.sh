#!/bin/bash

# rust is required (use rustup)
if rust_loc=$(type -p "cargo") || ! [ -z "$rust_loc" ];then
  export CARGO_HOME=$(pwd)
  export PATH=$PATH:$CARGO_HOME/bin

  git clone https://github.com/eza-community/eza
  cd eza
  cargo build --release
  cp ./target/release/eza $HOME/Develop/usr/bin
  cd $CARGO_HOME &&
    rm -rf ./eza &&
    rm -rf ./registry &&
    rm -r ./.package-cache

else
  echo "Rust is required. Please install with rustup."
fi
