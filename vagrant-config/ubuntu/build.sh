export HOME=/home/vagrant

# Update Locale
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Create Symlinks
mkdir /vagrant/development
mkdir /vagrant/tmp
ln -s /vagrant/development $HOME/development

# Install Common Packages
sudo apt-get -y autoremove
sudo apt-get update
sudo apt-get -y install vim git zsh build-essential make curl unzip \
sed emacs xorg dwm xrdp gnutls-bin sqlite3 fonts-hack-ttf binutils gcc

# Clone Environment
git clone https://github.com/imdaveho/environment.git /vagrant/tmp/environment
ln -s /vagrant/tmp/environment/emacs-config/.spacemacs $HOME/.spacemacs

# Oh My Zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
# Oh My Zsh Theme
# curl -o ~/.oh-my-zsh/custom/babun.zsh-theme \
# https://raw.githubusercontent.com/imdaveho/environment/master/shell-config/vagrant-babun.zsh-theme
ln -s /vagrant/tmp/environment/shell-config/vagrant-babun.zsh-theme $HOME/.oh-my-zsh/custom/babun.zsh-theme
# Oh My Zsh Config
# curl -o ~/.zshrc https://raw.githubusercontent.com/imdaveho/environment/master/shell-config/vagrant-zshrc
ln -s /vagrant/tmp/environment/shell-config/vagrant-zshrc $HOME/.zshrc

# Emacs (Spacemacs)
git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d


# [py] http://askubuntu.com/questions/21547/what-are-the-packages-libraries-i-should-install-before-compiling-python-from-so
# [rb] https://gorails.com/setup/ubuntu/16.04
# [php] http://www.tecmint.com/install-and-compile-php-7-on-centos-7-and-debian-8/
sudo apt-get -y install libz-dev libreadline-dev libncursesw5-dev libssl-dev \
libgdbm-dev libsqlite3-dev libbz2-dev liblzma-dev libdb-dev tk-dev python-dev \
python3-dev python-software-properties

sudo apt-get -y install zlib1g-dev libyaml-dev libxml2-dev libxslt1-dev \
libcurl4-openssl-dev libffi-dev

sudo apt-get -y install libjpeg-dev libpng-dev libxpm-dev libicu-dev bison \
libfreetype6-dev libmcrypt-dev libpspell-dev librecode-dev apache2-dev libgmp-dev

mkdir $HOME/.virtualenvs

# Configure programming languages
PYZSH="
# PYENV
export PYENV_ROOT=\"\${HOME}/.pyenv\"
if [ -d \"\${PYENV_ROOT}\" ];then
    export PATH=\"\${PYENV_ROOT}/bin:\${PATH}\"
    eval \"\$(pyenv init -)\"
    # standardizing path for all package managers to single directory (i.e. ~/local-pkgs)
    # eval \"\$(pyenv virtualenv-init -)\"
fi
"
RBZSH="
# RBENV
export RBENV_ROOT=\"\${HOME}/.rbenv\"
if [ -d \"\${RBENV_ROOT}\" ];then
    export PATH=\"\${RBENV_ROOT}/bin:\${PATH}\"
    eval \"\$(rbenv init -)\"
fi
"
JSZSH="
# NODENV
export NODENV_ROOT=\"\${HOME}/.nodenv\"
if [ -d \"\${NODENV_ROOT}\" ];then
    export PATH=\"\${NODENV_ROOT}/bin:\${PATH}\"
    eval \"\$(nodenv init -)\"
fi
"
PHPZSH="
# PHPENV
export PHPENV_ROOT=\"\${HOME}/.phpenv\"
if [ -d \"\${PHPENV_ROOT}\" ];then
    export PATH=\"\${PHPENV_ROOT}/bin:\${PATH}\"
    eval \"\$(phpenv init -)\"
fi
"
LUAZSH="
# LUAENV
export LUAENV_ROOT=\"\${HOME}/.luaenv\"
if [ -d \"\${LUAENV_ROOT}\" ];then
    export PATH=\"\${LUAENV_ROOT}/bin:\${PATH}\"
    eval \"\$(luaenv init -)\"
fi
"

args="$*"
if [ -n "$args" ]; then
    for var in $args
    do
	if [ "$var" = "mysql" -o "$args" = *"all"* ]; then
	    sudo apt-get -y install libmysqlclient-dev

	elif [ "$var" = "postgresql" -o "$args" = *"all"* ]; then
	    sudo apt-get -y install postgresql postgresql-contrib libpq-dev postgresql-server-dev-all
        
    	elif [ "$var" = "python" -o "$args" = *"all"* ]; then
            git clone https://github.com/yyuu/pyenv.git $HOME/.pyenv
	    echo "${PYZSH}" >> $HOME/.zshrc
	    export PATH=$HOME/.pyenv/bin:$PATH
	    pyenv install 3.5.2
	    pyenv install 2.7.12
	    mkdir $HOME/.virtualenvs/venvs
        
    	elif [ "$var" = "ruby" -o "$args" = *"all"* ]; then
            git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv
            git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
	    echo "${RBZSH}" >> $HOME/.zshrc
            export PATH=$HOME/.rbenv/bin:$PATH
	    rbenv install 2.3.1
	    mkdir $HOME/.virtualenvs/gemsets
        
    	elif [ "$var" = "node" -o "$args" = *"all"* ]; then
            git clone https://github.com/OiNutter/nodenv.git $HOME/.nodenv
            git clone https://github.com/OiNutter/node-build.git $HOME/.nodenv/plugins/node-build
	    echo "${JSZSH}" >> $HOME/.zshrc
	    export PATH=$HOME/.nodenv/bin:$PATH
	    nodenv install 6.4.0
	# the below require more use to see if it works as intended
    	elif [ "$var" = "php" -o "$args" = *"all"* ]; then
	    git clone https://github.com/madumlao/phpenv.git $HOME/.phpenv
	    git clone https://github.com/php-build/php-build.git $HOME/.phpenv/plugins/php-build
	    echo "${PHPZSH}" >> $HOME/.zshrc
	    export PATH=$HOME/.phpenv/bin:$PATH
	    phpenv install 7.0.9
	    # phpenv install 5.3.10

	elif [ "$var" = "go" -o "$args" = *"all"* ]; then
	    # consider forking rbenv to make it work for go, etc
	    zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
	    source $HOME/.gvm/scripts/gvm
	    gvm install go1.4.3 -B
	    gvm use go1.4.3
	    export GOROOT_BOOTSTRAP=$GOROOT
	    gvm install go1.7
	    gvm uninstall go1.4.3

	elif [ "$var" = "java" -o "$args" = *"all"* ]; then
	    # use jvm to manage versions with .java-version
	    # git clone https://github.com/caarlos0/jvm.git $HOME/.jvm
	    # use jabba to handle the installation JDKs
	    curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && $HOME/.jabba/jabba.sh
	
        elif [ "$var" = "groovy" -o "$var" = "scala" -o "$args" = *"all"* ]; then
	    curl -s "https://get.sdkman.io" | bash
	    source $HOME/.sdkman/bin/sdkman-init.sh
    
    	elif [ "$var" = "rust" -o "$args" = *"all"* ]; then
	    # official rust version manager
	    curl https://sh.rustup.rs -sSf | sh
	
    	elif [ "$var" = "lua" -o "$args" = *"all"* ]; then
	    git clone https://github.com/cehoffman/luaenv.git $HOME/.luaenv
	    git clone https://github.com/cehoffman/lua-build.git $HOME/.luaenv/plugins/lua-build
	    echo "${LUAZSH}" >> $HOME/.zshrc
	    export PATH=$HOME/.luaenv/bin:$PATH
	    luaenv install 5.3
        fi
    done
fi

# Duplicate .zshrc -> .zshenv for use with GUI Emacs
cp /vagrant/tmp/environment/shell-config/vagrant-zshrc $HOME/.zshenv
sudo chsh -s $(which zsh) vagrant
