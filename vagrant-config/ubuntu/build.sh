#!/bin/bash

export HOME=/home/vagrant
VBOX_NAME="vagrant"

# Update Locale
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Create Symlinks
mkdir /vagrant/development
mkdir /vagrant/tmp
ln -s /vagrant/development $HOME/development
ln -s /vagrant/tmp $HOME/tmp

# Install Common Packages
sudo apt-get -y autoremove
sudo apt-get update
sudo apt-get -y install vim git zsh build-essential make cmake curl unzip \
sed emacs gnutls-bin sqlite3 fonts-hack-ttf binutils

# Install Common C packages
sudo apt-get -y install gcc gdb lldb llvm clang-3.8 g++

# Clone Environment
git clone https://github.com/imdaveho/environment.git /vagrant/tmp/environment
ln -s /vagrant/tmp/environment/emacs-config/.spacemacs $HOME/.spacemacs

# Oh My Zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

# Oh My Zsh Theme
THEME_SETTINGS="
local return_code=\"%(?..%{\$fg[red]%}%? %{\$reset_color%})\"

PROMPT='%{\$fg[blue]%}{ %{\$fg[magenta]%}${VBOX_NAME}%{\$fg[yellow]%}::%{\$fg[blue]%}%c } \\
%{\$fg[green]%}\$(  git rev-parse --abbrev-ref HEAD 2> /dev/null || echo \"\"  )%{\$reset_color%}\\
%{\$fg[red]%}%(!.#.»)%{\$reset_color%} '

PROMPT2='%{\$fg[red]%}\ %{\$reset_color%}'

RPS1='%{\$fg[blue]%}%~%{\$reset_color%} \${return_code} '

ZSH_THEME_GIT_PROMPT_PREFIX=\"%{\$reset_color%}:: %{\$fg[yellow]%}(\"
ZSH_THEME_GIT_PROMPT_SUFFIX=\")%{\$reset_color%} \"
ZSH_THEME_GIT_PROMPT_CLEAN=\"\"
ZSH_THEME_GIT_PROMPT_DIRTY=\"%{\$fg[red]%}*%{\$fg[yellow]%}\"
"

touch $HOME/.oh-my-zsh/custom/babun.zsh-theme
echo "{$THEME_SETTINGS}" >> $HOME/.oh-my-zsh/custom/babun.zsh-theme

# Oh My Zsh Config
cp /vagrant/tmp/environment/shell-config/vagrant-zshrc $HOME/.zshrc

# Emacs (Spacemacs)
git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

# Install termite
sudo apt-get install -y libgtk-3-dev gtk-doc-tools valac intltool libpcre2-dev \
libglib3.0-cil-dev libgnutls28-dev libgirepository1.0-dev libxml2-utils gperf

echo export LIBRARY_PATH=/usr/include/gtk-3.0:$LIBRARY_PATH
mkdir -p $HOME/tmp/tools
git clone --recursive https://github.com/thestinger/termite.git $HOME/tmp/tools/termite
git clone https://github.com/thestinger/vte-ng.git $HOME/tmp/tools/vte-ng

cd $HOME/tmp/tools/vte-ng && ./autogen.sh && make && sudo make install
cd $HOME/tmp/tools/termite && make && sudo make install
sudo ldconfig
sudo mkdir -p /lib/terminfo/x; sudo ln -s \
/usr/local/share/terminfo/x/xterm-termite \
/lib/terminfo/x/xterm-termite

mkdir -p $HOME/.config/termite
cp $HOME/tmp/environment/shell-config/babun-termite $HOME/.config/termite/config

# exa (rust will be installed)
cd $HOME/tmp/tools
curl https://sh.rustup.rs -sSf >> rustup.sh
sh rustup.sh -y
rm rustup.sh
source $HOME/.cargo/env
git clone https://github.com/ogham/exa
cd exa
# TODO: investigate why regular make won't work
# and gives cannot change permissions error on run
sudo make install
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> $HOME/.zshrc
echo '' >> $HOME/.zshrc
echo 'alias lk="exa -ghlaHTL 2 --git"' >> $HOME/.zshrc

# mkdir $HOME/.virtualenvs

# Configure programming languages
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0

ASDF="
# ASDF-VM
if [ -d \"\${HOME}/.asdf\" ];then
    . \${HOME}/.asdf/asdf.sh
    . \${HOME}/.asdf/completions/asdf.bash
fi
"
DIRENV="
#DIRENV
if direnv_loc=\"\$(type -p \"direnv\")\" || [ -z \"\${direnv_loc}\" ];then
    eval \"\$(direnv hook zsh)\"
fi
"
echo "${ASDF}" >> $HOME/.zshrc
echo "${DIRENV}" >> $HOME/.zshrc

# Manually do the above since bash is running

if [ -d "${HOME}/.asdf" ];then
    . ${HOME}/.asdf/asdf.sh
    . ${HOME}/.asdf/completions/asdf.bash
fi

# [py] http://askubuntu.com/questions/21547/what-are-the-packages-libraries-i-should-install-before-compiling-python-from-so
# [rb] https://gorails.com/setup/ubuntu/16.04
# [php] http://www.tecmint.com/install-and-compile-php-7-on-centos-7-and-debian-8/
# [php] http://jcutrer.com/howto/linux/how-to-compile-php7-on-ubuntu-14-04
# [php] maybe worth installing, but not necessary: libfcgi-dev

# sudo apt-get -y install zip direnv libgtk2.0 libnss3 libtool unixodbc-dev \
# libxslt-dev libncurses-dev 

sudo apt-get -y install direnv

# Install functions
function install_mysql() {
    sudo apt-get -y install libmysqlclient-dev mysql-client
}

function install_postgres() {
    sudo apt-get -y install postgresql postgresql-contrib libpq-dev postgresql-server-dev-all
}

function install_x() {
	  # Install for startx to work on Ubuntu/Xenial64
	  sudo apt-get -y install xorg dwm xrdp xserver-xorg-legacy
	  sudo apt-get -y install virtualbox-guest-x11 virtualbox-guest-dkms
}

function install_wayland() {
	  echo "wayland is not supported yet"
    install_x
}

function install_python() {
    sudo apt-get install -y libz-dev libreadline-dev libncursesw5-dev libssl-dev libgdbm-dev \
         libsqlite3-dev libbz2-dev liblzma-dev libdb-dev tk-dev
    asdf plugin-add python https://github.com/tuvistavie/asdf-python
    asdf install python 2.7.13
    asdf install python 3.6.1
    # mkdir $HOME/.virtualenvs/venvs
}

function install_ruby() {
    sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev \
         libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev \
         python-software-properties libffi-dev nodejs
    asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby
    asdf install ruby 2.4.1
    # mkdir $HOME/.virtualenvs/gemsets
}

function install_node() {
    asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs
    echo export GNUPGHOME="$HOME/.asdf/keyrings/nodejs" && mkdir -p "$GNUPGHOME" && chmod 0700 "$GNUPGHOME"
    bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
    asdf install nodejs 7.10.0
}

function install_php() {
    sudo apt-get install -y libxml2-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libxpm-dev \
         libmysqlclient-dev libicu-dev libfreetype6-dev libxslt-dev libssl-dev libbz2-dev \
         libgmp-dev libmcrypt-dev libpspell-dev librecode-dev apache2-dev bison autoconf \
         libtidy-dev re2c libedit-dev
    asdf plugin-add php https://github.com/odarriba/asdf-php
    asdf install php 7.0.11
}

function install_go() {
    asdf plugin-add golang https://github.com/kennyp/asdf-golang
    asdf install golang 1.8.1
}

function install_lua() {
    asdf plugin-add lua https://github.com/Stratus3D/asdf-lua
    asdf install lua 5.3.4
}

function install_haskell() {
    asdf plugin-add haskell https://github.com/vic/asdf-haskell
    asdf install haskell 8.0.2
}

function install_jvm() {
    curl -s "https://get.sdkman.io" | bash
    source $HOME/.sdkman/bin/sdkman-init.sh
}

function install_all() {
    install_mysql
    install_postgres
    install_python
    install_ruby
    install_node
    install_php
    install_go
    install_lua
    install_haskell
    install_jvm
}

args=$*
if [ -n "$args" ]; then
    if [[ "$args" = *"all"* ]]; then
        install_all
    fi
    for var in $args; do
        if [[ "$var" == "x" ]]; then
            install_x
	      elif [[ "$var" == "wayland" ]]; then
            install_wayland
        elif [[ "$var" = "mysql" ]]; then
            install_mysql
	      elif [[ "$var" = "postgresql" ]]; then
            install_postgres
	      elif [[ "$var" = "python" ]]; then
            install_python
	      elif [[ "$var" = "ruby" ]]; then
            install_ruby
        elif [[ "$var" = "node" ]]; then
            install_node
        elif [[ "$var" = "php" ]]; then 
            install_php
        elif [[ "$var" = "go" ]]; then
            install_go
        elif [[ "$var" = "lua" ]]; then
            install_lua
        elif [[ "$var" = "haskell" ]]; then
            install_haskell
        elif [[ "$var" = "java" || "$var" = "groovy" || "$var" = "scala" || "$var" = "clojure" ]]; then
            install_jvm
        fi
    done
fi

# Duplicate .zshrc -> .zshenv for use with GUI Emacs
# cp /vagrant/tmp/environment/shell-config/vagrant-zshrc $HOME/.zshenv
sudo chsh -s $(which zsh) vagrant
