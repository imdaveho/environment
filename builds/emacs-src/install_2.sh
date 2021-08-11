#!/bin/bash

# TODO: ensure checkinstall is available

# Ensure dependencies are met:
# Debian (Buster) - Linux on ChromeOS
# from: https://www.emacswiki.org/emacs/BuildingEmacs
sudo apt install -y build-essential autoconf texinfo libgnutls28-dev libc6-dev libjpeg62-turbo libncurses5-dev libpng-dev libtiff5-dev libgif-dev xaw3dg-dev zlib1g-dev libx11-dev libcairo2-dev

git clone --depth=1 --branch emacs-27.2 https://github.com/emacs-mirror/emacs
cd emacs

mkdir -p "$HOME/devel/usr/build/emacs27.2"
# Create summary for checkinstall
touch description-pak && echo "GNU Emacs is an extensible, customizable text editor - and more. At its core is an interpreter for Emacs Lisp, a dialect of the Lisp programming language with extensions to support text editing." >> description-pak

# Configure build
./autogen.sh
./configure --prefix="$HOME/devel/usr/build/emacs27.2" --datarootdir="$HOME/.local/share" --with-gnutls --with-cairo --with-dbus
# Build Emacs
make && checkinstall --install=no --fstrans=no --pkgversion="27.2" --maintainer="org.gnu.emacs" -y && cp ./*.deb "$HOME/devel/usr/build/emacs27.2/" && \
  make uninstall && \
  cd "$HOME/devel/usr/build/emacs27.2" && \
  sudo dpkg -i "emacs_27.2-1_amd64.deb"

# Cleanup
cd $HOME/devel/usr/src/emacs-src
rm -rf emacs
