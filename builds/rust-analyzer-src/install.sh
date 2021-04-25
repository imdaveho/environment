#!/bin/bash

# rust is required (use rustup)
if rust_path=$(type -p "cargo") || ! [ -z "$rust_path" ];then
  HERE=$(pwd)
  export CARGO_HOME=$HERE/cargo
  export PATH=$PATH:$CARGO_HOME/bin

  git clone https://github.com/rust-analyzer/rust-analyzer
  cd rust-analyzer
  cargo xtask install --server

  cd $HERE && cp ./cargo/bin/rust-analyzer \
    $HOME/devel/usr/bin &&
    rm -rf ./rust-analyzer &&
    rm -rf ./cargo
else
  echo "Rust is required. Please install with rustup"
fi
