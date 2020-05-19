#!/bin/bash

# rust is required (use rustup)
if rust_loc=$(type -p "cargo") || ! [ -z "$rust_loc" ];then
  export CARGO_HOME=$(pwd)
  export PATH=$PATH:$CARGO_HOME/bin

  git clone https://github.com/rust-analyzer/rust-analyzer
  cd rust-analyzer
  cargo build --release
  cp ./target/release/rust-analyzer $HOME/devel/usr/bin
  cd $CARGO_HOME &&
    rm -rf ./rust-analyzer &&
    rm -rf ./registry &&
    rm -f ./.package-cache

else
  echo "Rust is required. Please install with rustup."
fi
