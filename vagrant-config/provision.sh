# Update Locale
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Create Symlinks
mkdir /vagrant/development
mkdir /vagrant/tmp
ln -s /vagrant/development ./development

# Install Common Packages
sudo apt-get -y autoremove
sudo apt-get update
sudo apt-get -y install git zsh build-essential make curl emacs xorg dwm xrdp gnutls-bin sqlite3 fonts-hack-ttf

# Oh My Zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
# Oh My Zsh Theme
curl -o ~/.oh-my-zsh/custom/babun.zsh-theme \
https://raw.githubusercontent.com/imdaveho/environment/master/shell-config/vagrant-babun.zsh-theme
# Oh My Zsh Config
curl -o ~/.zshrc https://raw.githubusercontent.com/imdaveho/environment/master/shell-config/vagrant-zshrc

# Duplicate .zshrc -> .zshenv for use with GUI Emacs
cp ~/.zshrc ~/.zshenv
chsh -s $(which zsh) vagrant

# Emacs (Spacemacs)
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# Clone Environment
git clone https://github.com/imdaveho/environment.git /vagrant/tmp
ln -s /vagrant/tmp/environment/emacs-config/.spacemacs ~/.spacemacs


# [py] http://askubuntu.com/questions/21547/what-are-the-packages-libraries-i-should-install-before-compiling-python-from-so
# [rb] https://gorails.com/setup/ubuntu/16.04
# [php] http://www.tecmint.com/install-and-compile-php-7-on-centos-7-and-debian-8/
sudo apt-get -y install libz-dev libreadline-dev libncursesw5-dev libssl-dev \
libgdbm-dev libsqlite3-dev libbz2-dev liblzma-dev libdb-dev tk-dev python-dev \
python3-dev python-software-properties \
\
zlib1g-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev \ 
\
libjpeg-dev libpng-dev libxpm-dev libicu-dev libfreetype6-dev libmcrypt-dev \
libpspell-dev librecode-dev apache2-dev libgmp-dev

# Configure programming languages
args="$*"
if [ -n "$args" ]; then
    for var in $args
    do
        if [ "$var" = "python" -o "$args" = *"all"* ]; then
            git clone https://github.com/yyuu/pyenv.git ~/.pyenv
	    pyenv install 3.5.2
	    pyenv install 2.7.12
        elif [ "$var" = "ruby" -o "$args" = *"all"* ]; then
            git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
            git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
            rbenv install 2.3.1
        elif [ "$var" = "node" -o "$args" = *"all"* ]; then
            git clone https://github.com/OiNutter/nodenv.git ~/.nodenv
            git clone https://github.com/OiNutter/node-build.git ~/.nodenv/plugins/node-build
	    nodenv install 6.4.0
	elif [ "$var" = "mysql" -o "$args" = *"all"* ]; then
	    sudo apt-get -y install libmysqlclient-dev
	elif [ "$var" = "postgresql" -o "$args" = *"all"* ]; then
	    sudo apt-get -y install postgresql postgresql-contrib libpq-dev postgresql-server-dev-all
        fi
    done
else
fi
