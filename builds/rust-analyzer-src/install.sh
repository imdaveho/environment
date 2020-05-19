#!/bin/bash

# rust is required (use rustup)
if rust_path=$(type -p "cargo") || ! [ -z "$rust_path" ];then
  export CARGO_HOME=$(pwd)
  export PATH=$PATH:$CARGO_HOME/bin
  # HERE=$(pwd)
  # export CARGO_HOME=$HERE/cargo
  # export PATH=$PATH:$CARGO_HOME/bin

  git clone https://github.com/rust-analyzer/rust-analyzer
  cd rust-analyzer

  cargo build --release
  cp ./target/release/rust-analyzer $HOME/devel/usr/bin
  cd $CARGO_HOME &&
    rm -rf ./rust-analyzer &&
    rm -rf ./registry &&
    rm -f ./.package-cache
  # cargo install --path ./crates/ra_lsp_server
  # cp $CARGO_HOME/bin/ra_lsp_server $HOME/devel/usr/bin
  # cd $HERE &&
  #   rm -rf ./rust-analyzer &&
  #   rm -rf ./cargo
else
  echo "Rust is required. Please install with rustup"
fi
