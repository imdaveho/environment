#!/bin/bash

# TODO: ensure checkinstall is available

# Ensure dependencies are met:
# Debian (Buster) - Linux on ChromeOS
# from: https://www.emacswiki.org/emacs/BuildingEmacs
# sudo apt install -y build-essential autoconf texinfo libgnutls28-dev libc6-dev libjpeg62-turbo libncurses5-dev libpng-dev libtiff5-dev libgif-dev xaw3dg-dev zlib1g-dev libx11-dev libcairo2-dev

# Ubuntu (Groovy 20.10)
# sudo apt install -y build-essential autoconf texinfo libgnutls28-dev libc6-dev libncurses5-dev libpng-dev libtiff5-dev libgif-dev xaw3dg-dev zlib1g-dev libx11-dev libcairo2-dev libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev
# # The below were from `apt-get build-dep emacs`:
# libacl1-dev libasound2-dev libatk-bridge2.0-dev libatk1.0-dev \
# libatspi2.0-dev libattr1-dev libcairo-script-interpreter2 libcairo2-dev \
# libdatrie-dev libdbus-1-dev libdjvulibre-dev libegl-dev libegl1-mesa-dev \
# libepoxy-dev libevent-2.1-7 libexif-dev libfribidi-dev libgdk-pixbuf2.0-dev \
# libgif-dev libgl-dev libgl1-mesa-dev libgles-dev libgles1 libglvnd-dev \
# libglx-dev libgmp-dev libgmpxx4ldbl libgnutls-dane0 libgnutls-openssl27 \
# libgnutls28-dev libgnutlsxx28 libgpm-dev libgraphite2-dev libgtk-3-dev \
# libharfbuzz-dev libharfbuzz-gobject0 libidn2-dev libilmbase-dev libjbig-dev \
# libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev liblcms2-dev liblockfile-bin \
# liblockfile-dev liblockfile1 liblqr-1-0-dev libltdl-dev libm17n-0 \
# libm17n-dev libmagick++-6-headers libmagick++-6.q16-8 libmagick++-6.q16-dev \
# libmagickcore-6-arch-config libmagickcore-6-headers libmagickcore-6.q16-dev \
# libmagickwand-6-headers libmagickwand-6.q16-dev libopenexr-dev libopengl-dev \
# libopengl0 libotf-dev libotf0 libp11-kit-dev libpango1.0-dev libpixman-1-dev \
# librsvg2-dev libsystemd-dev libtasn1-6-dev libthai-dev libtiff-dev \
# libtiffxx5 libunbound8 libwayland-bin libwayland-dev libwmf-dev libxaw7-dev \
# libxcb-render0-dev libxcb-shm0-dev libxcomposite-dev libxcursor-dev \
# libxdamage-dev libxfixes-dev libxi-dev libxinerama-dev libxkbcommon-dev \
# libxmu-dev libxmu-headers libxpm-dev libxrandr-dev libxtst-dev m17n-db \
# nettle-dev pango1.0-tools wayland-protocols x11proto-input-dev \
# x11proto-randr-dev x11proto-record-dev x11proto-xinerama-dev xaw3dg \
# xaw3dg-dev xutils-dev libjansson4 libjansson-dev
# (deleted bsd-mailx and postfix)

git clone --depth=1 --branch emacs-27.2 https://github.com/emacs-mirror/emacs
cd emacs

mkdir -p "$HOME/devel/usr/build/emacs27.2"
# Create summary for checkinstall
touch description-pak && echo "GNU Emacs is an extensible, customizable text editor - and more. At its core is an interpreter for Emacs Lisp, a dialect of the Lisp programming language with extensions to support text editing." >> description-pak

# Configure build
./autogen.sh
# ./configure --prefix="$HOME/devel/usr/build/emacs27.2" --datarootdir="$HOME/.local/share" --with-gnutls --with-cairo --with-dbus --with-json

# If blessmail errors (not sure why) then:
# sudo apt install -y mailutils
./configure --prefix="$HOME/devel/usr/build/emacs27.2" --datarootdir="$HOME/.local/share" --with-gnutls --with-cairo --with-dbus --with-mailutils --with-json

# Build Emacs (ChromeOS / chroot)
# make && checkinstall --install=no --fstrans=no --pkgversion="27.2" --maintainer="org.gnu.emacs" -y && cp ./*.deb "$HOME/devel/usr/build/emacs27.2/" && \

# Build Emacs (Linux)
make && checkinstall --install=no --pkgversion="27.2" --maintainer="org.gnu.emacs" -y && cp ./*.deb "$HOME/devel/usr/build/emacs27.2/" && \
 make uninstall && \
 cd "$HOME/devel/usr/build/emacs27.2" && \
 sudo dpkg -i "emacs_27.2-1_amd64.deb"

# Cleanup
cd $HOME/devel/usr/src/emacs-src
rm -rf emacs
