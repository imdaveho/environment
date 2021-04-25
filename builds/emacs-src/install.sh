#!/bin/bash

# Ensure dependencies are met:
# checkinstall may need a new source to be added to /etc/apt/sources.list.d/
# sudo apt install -y checkinstall

# Debian (Buster) - Linux on ChromeOS
# from: https://www.emacswiki.org/emacs/BuildingEmacs
sudo apt install -y autoconf texinfo libgnutls28-dev libc6-dev libjpeg62-turbo libncurses5-dev libpng-dev libtiff5-dev libgif-dev xaw3dg-dev zlib1g-dev libx11-dev libgtk-3-dev libwebkit2gtk-4.0-dev

git clone --depth=1 --branch emacs-27 https://github.com/emacs-mirror/emacs
cd emacs

./autogen.sh
./configure --with-gnutls --with-cairo --with-dbus --with-xwidgets --with-x-toolkit=gtk3
# Install with checkinstall to create the .deb file
# sudo checkinstall --pkgversion="27.2" --maintainer="org.gnu.emacs" --install=no
# ChromeOS permissions workaround:
sudo checkinstall --pkgversion="27.2" --maintainer="org.gnu.emacs" --install=no --fstrans=no && \

  # Uninstall from make
  cp ./*.deb ../ && sudo make uninstall && \
  # Cleanup
  cd .. && sudo rm -rf emacs
