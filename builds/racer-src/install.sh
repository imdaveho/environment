#!/bin/bash

# rust is required (use rustup)
if rust_loc=$(type -p "cargo") || ! [ -z "$rust_loc" ];then
  export CARGO_HOME=$(pwd)
  export PATH=$PATH:$CARGO_HOME/bin

  git clone https://github.com/racer-rust/racer
  cd racer
  cargo +nightly build --release
  cp ./target/release/racer $HOME/devel/usr/bin
  cd $CARGO_HOME &&
    rm -rf ./racer &&
    rm -rf ./registry &&
    rm -f ./.package-cache

else
  echo "Rust is required. Please install with rustup."
fi
