#!/bin/bash

# Update environment
sudo apt update
sudo apt -y upgrade

# Environment Paths
export CURR_DIR=$(pwd)
export BUILD_SCRIPTS="$CURR_DIR/builds"
export DOTFILES="$CURR_DIR/dotfiles"

# User Paths
export SRC_DIR="$HOME/devel/usr/src"

# Move build scripts to the src path
mkdir -p $SRC_DIR
cp -r $BUILD_SCRIPTS/* $SRC_DIR

# Handle dotfiles and config (bashrc and doom.d)
mv $HOME/.bashrc $HOME/.bashrc.backup
cp $DOTFILES/bashrc $HOME/.bashrc
cp $DOTFILES/bash_aliases $HOME/.bash_aliases
cp -r $DOTFILES/doom.d $HOME/.doom.d

# Get core packages
sudo apt -y install make git curl neovim build-essential binutils cmake

# Python build dependencies
sudo apt install libbz2-dev libncursesw5-dev libgdbm-dev liblzma-dev libsqlite3-dev tk-dev uuid-dev libreadline-dev libffi-dev zlib1g-dev

# Emacs build dependencies
sudo apt install autoconf gcc texinfo libgtk-3-dev libxpm-dev libjpeg-dev libgif-dev libtiff5-dev libgnutls28-dev libncurses5-dev libcairo2-dev libotf-dev m17n-db libm17n-dev libpng-dev libz-dev libdbus-1-dev librsvg2-dev

# Get asdf-vm
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
# python nim golang nodejs haskell ruby

# Get rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# rustup component add rust-src
# rustup toolchain add nightly
# rustup default nightly
# rustup component add rust-src
# rustup default stable

# Get sdkman
curl -s "https://get.sdkman.io" | bash
# source "$HOME/.sdkman/bin/sdkman-init.sh"
# java 11.0.7.hs-adpt leiningen

# Ruby build dependencies
# TBD


# Initialize project directory
mkdir "$HOME/devel/rust" "$HOME/devel/python" "$HOME/devel/nodejs" "$HOME/devel/nim" "$HOME/devel/golang"

# Initialize main projects
cd "$HOME/devel/rust" && git clone "https://github.com/imdaveho/tuitty"
