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
# curl -o ~/.oh-my-zsh/custom/babun.zsh-theme \
# https://raw.githubusercontent.com/imdaveho/environment/master/shell-config/vagrant-babun.zsh-theme
# ln -s /vagrant/tmp/environment/shell-config/vagrant-babun.zsh-theme $HOME/.oh-my-zsh/custom/babun.zsh-theme
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
# curl -o ~/.zshrc https://raw.githubusercontent.com/imdaveho/environment/master/shell-config/vagrant-zshrc
# ln -s /vagrant/tmp/environment/shell-config/vagrant-zshrc $HOME/.zshrc
cp /vagrant/tmp/environment/shell-config/vagrant-zshrc $HOME/.zshrc

# Emacs (Spacemacs)
git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d


# [py] http://askubuntu.com/questions/21547/what-are-the-packages-libraries-i-should-install-before-compiling-python-from-so
# [rb] https://gorails.com/setup/ubuntu/16.04
# [php] http://www.tecmint.com/install-and-compile-php-7-on-centos-7-and-debian-8/
# [php] http://jcutrer.com/howto/linux/how-to-compile-php7-on-ubuntu-14-04
# [php] maybe worth installing, but not necessary: libfcgi-dev 
sudo apt-get -y install libz-dev libreadline-dev libncursesw5-dev libssl-dev \
libgdbm-dev libsqlite3-dev libbz2-dev liblzma-dev libdb-dev tk-dev python-dev \
python3-dev python-software-properties libssh-dev libssh2-1-dev libgit2-dev \
python-pip python-setuptools

sudo apt-get -y install zlib1g-dev libyaml-dev libxml2-dev libxslt1-dev \
libcurl4-openssl-dev libffi-dev

sudo apt-get -y install libjpeg-dev libpng-dev libxpm-dev libicu-dev bison \
libfreetype6-dev libmcrypt-dev libpspell-dev librecode-dev apache2-dev libgmp-dev \
autoconf libtidy-dev re2c

sudo apt-get -y install zip direnv libgtk2.0 libnss3 libtool unixodbc-dev \
libxslt-dev libncurses-dev libedit-dev

# Install termite
sudo apt-get install -y libgtk-3-dev gtk-docs-tools valac intltool libpcre2-dev \
libglib3.0-cil-dev libgnutls28-dev libgirepository1.0-dev libxml2-utils gperf

echo export LIBRARY_PATH=/usr/include/gtk-3.0:$LIBRARY_PATH
mkdir -p $HOME/tmp/tools
git clone --recursive https://github.com/thestinger/termite.git $HOME/tmp/tools/termite
git clone https://github.com/thestinger/vte-ng.git $HOME/tmp/tools/vte-ng

cd $HOME/tmp/vte-ng && ./autogen.sh && make && sudo make install
cd ../termite && make && sudo make install
sudo ldconfig
sudo mkdir -p /lib/terminfo/x; sudo ln -s \
/usr/local/share/terminfo/x/xterm-termite \
/lib/terminfo/x/xterm-termite

mkdir -p $HOME/.config/termite
cp $HOME/tmp/environment/shell-config/babun-termite $HOME/.config/termite/config

mkdir $HOME/.virtualenvs

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

args="$*"
if [ -n "$args" ]; then
    for var in $args
    do
	      if [ "$var" = "mysql" -o "$args" = *"all"* ]; then
            sudo apt-get -y install libmysqlclient-dev mysql-client

	      elif [ "$var" = "postgresql" -o "$args" = *"all"* ]; then
            sudo apt-get -y install postgresql postgresql-contrib libpq-dev postgresql-server-dev-all

	      elif [ "$var" = "x" ]; then
            # Install for startx to work on Ubuntu/Xenial64
            sudo apt-get -y install xorg dwm xrdp xserver-xorg-legacy
            sudo apt-get -y install virtualbox-guest-x11 virtualbox-guest-dkms

	      elif [ "$var" = "wayland" ]; then
	          echo "wayland not supported yet"
	          # Install for startx to work on Ubuntu/Xenial64
	          sudo apt-get -y install xorg dwm xrdp xserver-xorg-legacy
	          sudo apt-get -y install virtualbox-guest-x11 virtualbox-guest-dkms

        elif [ "$var" = "python" -o "$args" = *"all"* ]; then
            asdf plugin-add python https://github.com/tuvistavie/asdf-python
	          asdf install python 2.7.13
	          asdf install python 3.6.1
	          mkdir $HOME/.virtualenvs/venvs

	      elif [ "$var" = "ruby" -o "$args" = *"all"* ]; then
            asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby
	          asdf install ruby 2.4.1
	          mkdir $HOME/.virtualenvs/gemsets

	      elif [ "$var" = "node" -o "$args" = *"all"* ]; then
            asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs
	          export GNUPGHOME="$HOME/.asdf/keyrings/nodejs" && mkdir -p "$GNUPGHOME" && chmod 0700 "$GNUPGHOME"
	          bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
	          asdf install nodejs 7.10.0

	          # the below require more use to see if it works as intended
	      elif [ "$var" = "php" -o "$args" = *"all"* ]; then
	          asdf plugin-add php https://github.com/odarriba/asdf-php
	          asdf install php 7.0.11
	          # asdf install php 5.3.10

	      elif [ "$var" = "go" -o "$args" = *"all"* ]; then
	          asdf plugin-add golang https://github.com/kennyp/asdf-golang
	          asdf install golang 1.8.1

	      elif [ "$var" = "rust" -o "$args" = *"all"* ]; then
	          # official rust version manager
	          curl https://sh.rustup.rs -sSfy | sh

	      elif [ "$var" = "lua" -o "$args" = *"all"* ]; then
	          asdf plugin-add lua https://github.com/Stratus3D/asdf-lua
	          asdf install lua 5.3.4

	      elif [ "$var" = "haskell" -o "$args" = *"all"* ]; then
	          asdf plugin-add haskell https://github.com/vic/asdf-haskell
	          asdf install haskell 8.0.2

	      elif [ "$var" = "java" -o
		           "$var" = "groovy" -o
		           "$var" = "scala" -o
		           "$var" = "clojure" -o
		           "$args" = *"all"* ]; then
	          curl -s "https://get.sdkman.io" | bash
	          source $HOME/.sdkman/bin/sdkman-init.sh
	      fi
    done
fi

# Duplicate .zshrc -> .zshenv for use with GUI Emacs
cp /vagrant/tmp/environment/shell-config/vagrant-zshrc $HOME/.zshenv
sudo chsh -s $(which zsh) vagrant
