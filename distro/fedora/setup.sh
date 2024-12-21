#!/bin/bash

echo "Setting up Fedora"
COLOR_R='\033[0;31m'
COLOR_G='\033[0;32m'
COLOR_Y='\033[0;33m'
COLOR_B='\033[0;34m'
COLOR_M='\033[0;35m'
COLOR_C='\033[0;36m'
COLOR_W='\033[0;37m'
RESET='\033[0m'
echo "=================================================="

# Get user password to pass to sudo
read -sp "➡ Store password: " SECRET && echo -e "\r"
sudo -S bash -c ":" <<< $SECRET
echo -e "[${COLOR_Y}password${RESET}]...${COLOR_G}OK${RESET}. 😎\n"


# Optimizing DNF
dnf_conf="/etc/dnf/dnf.conf"
conftext=(
    "gpgcheck=True"
    "installonly_limit=3"
    "clean_requirements_on_remove=True"
    "best=False"
    "skip_if_unavailable=True"
    "max_parallel_downloads=10"
    "fastestmirror=True")
echo "➡ Checking to see if '$dnf_conf' has been updated."
read -p "Press enter to continue."
for line in "${conftext[@]}"; do
    if ! grep -Fxqi "$line" $dnf_conf; then
	read -p "⇾ Append \"$line\" >> '$dnf_conf' [Y/n]? " input_data 
	input_data="${input_data:-Y}"
	if [[ "$input_data" =~ ^[Yy]$ ]]
	then
	    echo -e "++ Adding to '$dnf_conf': ${COLOR_G}$line${RESET}\n"
	    sudo -S bash -c "tee -a $dnf_conf <<< $line >/dev/null" <<< $SECRET
        else
	   echo -e "Skipping ${COLOR_R}$line${RESET}.\n"
    	fi
	unset input_data
    fi
done
unset conftext
unset dnf_conf
echo -e "[${COLOR_Y}dnf.conf${RESET}]...${COLOR_G}OK${RESET}. 😎\n"


# Install RPM Fusion
echo "➡ Installing RPM Fusion repos."
read -p "Press enter to continue."
mirror="https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo -S dnf -y install $mirror <<< $SECRET
mirror="https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
sudo -S dnf -y install $mirror <<< $SECRET
unset mirror
echo -e "[${COLOR_Y}rpmfusion${RESET}]...${COLOR_G}OK${RESET}. 😎\n"


# Set hostname
echo "➡ Update the hostname."
read -p "Enter hostname: " hostname
hostnamectl set-hostname "$hostname"
unset hostname
echo -e "[${COLOR_Y}hostname${RESET}]...${COLOR_G}OK${RESET}. 😎\n"


# Getting proper media playback
echo "➡ Setting up proper media codecs."
read -p "Press enter to continue."
# Switch to full FFMPEG.
sudo -S dnf -y swap 'ffmpeg-free' 'ffmpeg' --allowerasing 
sudo -S dnf4 -y group upgrade multimedia
# Installs gstreamer components. 
# Required if you use Gnome Videos and other dependent applications.
sudo -S dnf -y update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
# Installs useful Sound and Video complement packages.
sudo -S dnf -y update @sound-and-video 
echo -e "[${COLOR_Y}media codecs${RESET}]...${COLOR_G}OK${RESET}. 😎\n"


# Update the system
echo "➡ Updating the system."
read -p "Press enter to continue."
sudo -S dnf group upgrade -y core <<< $SECRET
sudo -S dnf4 group update -y core <<< $SECRET
sudo -S dnf -y update @core <<< $SECRET
sudo -S dnf -y update <<< $SECRET
echo -e "[${COLOR_Y}system update${RESET}]...${COLOR_G}OK${RESET}. 😎\n"


# Install necessary things
echo "➡ Removing unneeded apps, packages, and libraries."
read -p "Press enter to continue."
sudo -S dnf -y remove libreoffice* firefox <<< $SECRET
sudo -S dnf group remove -y libreoffice <<< $SECRET
echo -e "[${COLOR_Y}clean-up${RESET}]...${COLOR_G}OK${RESET}. 😎\n"

echo "➡ Installing default apps, packages, and libraries."
read -p "Press enter to continue."
echo "[flathub, zen, gnome-extensions, flatseal, neovim, gnome-tweaks, intel-media-driver, vlc, *python-build-dependencies]"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.github.zen_browser.zen org.gnome.Extensions com.github.tchx84.Flatseal md.obsidian.Obsidian io.github.realmazharhussain.GdmSettings
sudo -S dnf -y install neovim gnome-tweaks vlc intel-media-driver <<< $SECRET
echo -e "[${COLOR_Y}defaults install${RESET}]...${COLOR_G}OK${RESET}. 😎\n"

echo "➡ Installing Python build dependencies."
read -p "⇾ Proceed to install? [Y/n]? " input_data 
input_data="${input_data:-Y}"
if [[ "$input_data" =~ ^[Yy]$ ]]; then
    python_build_deps="make gcc patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel libuuid-devel gdbm-libs libnsl2"
    sudo -S dnf -y install $python_build_deps <<< $SECRET
    echo -e "[${COLOR_Y}python deps${RESET}]...${COLOR_G}OK${RESET}. 😎\n"
else
    echo -e "Skipping installation of ${COLOR_R}python build dependencies${RESET}.\n"
fi

echo "➡ Installing Emacs build dependencies."
read -p "⇾ Proceed to install? [Y/n]? " input_data 
input_data="${input_data:-Y}"
if [[ "$input_data" =~ ^[Yy]$ ]]; then
    emacs_build_deps="gcc make autoconf texinfo gnutls-devel libxml2-devel ncurses-devel gtk3-devel libgccjit-devel libtree-sitter-devel jansson-devel giflib-devel systemd-devel libotf-devel librsvg2-devel lcms2-devel alsa-lib-devel libacl-devel libappstream-glib gpm-devel m17n-lib-devel"
    sudo -S dnf -y install $emacs_build_deps <<< $SECRET
    echo -e "[${COLOR_Y}emacs deps${RESET}]...${COLOR_G}OK${RESET}. 😎\n"
    read -p "⇾ Build emacs from source? [Y/n]? " input_data 
    input_data="${input_data:-Y}"
    if [[ "$input_data" =~ ^[Yy]$ ]];then
	active_dir=$(pwd)
	EMACS_VER="29.3" # 29.4 (12.24.2024 Fedora 41 distro version)
	                 # causes issues with doomemacs and raises 
	                 # `doom doctor` warning. 
	source_dir=$HOME/Develop/usr/ext/source/
	cd $source_dir && wget https://ftp.gnu.org/gnu/emacs/emacs-$EMACS_VER.tar.xz
	tar xvf emacs-$EMACS_VER.tar.xz
	rm emacs-$EMACS_VER.tar.xz
	cd emacs-$EMACS_VER
	./configure --with-json --with-pgtk --with-tree-sitter --with-sound --with-native-compilation=aot
	make
	sudo -S make install <<< $SECRET
	cd $active_dir
    	echo -e "[${COLOR_Y}build emacs-$EMACS_VER${RESET}]...${COLOR_G}OK${RESET}. 😎\n"
    fi
else
    echo -e "Skipping installation of ${COLOR_R}Emacs build dependencies${RESET}.\n"
    read -p "⇾ Install distro version of emacs (dnf)? [Y/n]? " input_data 
    input_data="${input_data:-Y}"
    if [[ "$input_data" =~ ^[Yy]$ ]];then
	sudo -S dnf -y install emacs <<< $SECRET
        echo -e "[${COLOR_Y}distro emacs${RESET}]...${COLOR_G}OK${RESET}. 😎\n"
    fi
fi
unset python_build_deps
unset emacs_build_deps
unset EMACS_VER
unset source_dir
unset active_dir
unset input_data


# Setting up CodeWeavers CrossOver
echo "➡ Setting up CrossOver."
read -p "⇾ Proceed to setup? [y/N]? " input_data 
input_data="${input_data:-N}"
if [[ "$input_data" =~ ^[Yy]$ ]]; then
    sudo -S dnf -y install https://crossover.codeweavers.com/redirect/crossover.rpm <<< $SECRET
    echo "Installed CrossOver. Attempting to register."
    read -p "⇾ Ready to register? This requires the CodeWeavers account password. [y/N]? " input_data 
    input_data="${input_data:-N}"
    if [[ "$input_data" =~ ^[Yy]$ ]]; then
    	sudo -S /opt/cxoffice/bin/cxregister
    else
        echo -e "Skipping ${COLOR_R}CrossOver registration${RESET}.\n"
    fi
else
    echo -e "Skipping ${COLOR_R}CrossOver installation${RESET}.\n"
fi
unset input_data
echo -e "[${COLOR_Y}crossover${RESET}]...${COLOR_G}OK${RESET}. 😎\n"


# Setting up development environments
echo "➡ Setting up development directories."
read -p "Press enter to continue."
mkdir -p $HOME/Develop/code $HOME/Develop/usr
languages=(
    "golang"
    "python"
    "clojure"
    "nim"
    "nodejs"
    "rust"
    "scala"
    "lua"
    "java"
    "flutter"
)
for lang in "${languages[@]}"; do
    mkdir $HOME/Develop/code/$lang
done
unset languages
mkdir $HOME/Develop/usr/ext $HOME/Develop/usr/bin
sudo -S dnf -y install eza direnv ripgrep findutils fd rlwrap <<< $SECRET
echo -e "[${COLOR_Y}~/Develop${RESET}]...${COLOR_G}OK${RESET}. 😎\n"

# ASDF-VM
echo "➡ Cloning asdf-vm into \$HOME."
read -p "Press enter to continue."
JAVA_LTS="temurin-21.0.5+11.0.LTS"
NODE_LTS="22.12.0"

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
echo -e "Installing golang.\n"
sleep 1.25
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
asdf install golang latest
echo -e "Installing java.\n"
sleep 1.25
asdf plugin add java https://github.com/halcyon/asdf-java.git
asdf install java $JAVA_LTS 
echo -e "Installing clojure.\n"
sleep 1.25
asdf plugin add clojure https://github.com/asdf-community/asdf-clojure.git
asdf install clojure latest
echo -e "Installing nim.\n"
sleep 1.25
asdf plugin add nim # asdf-nim plugin
asdf nim install-deps  # system-specific deps for downloading & building Nim
asdf install nim latest
echo -e "Installing python.\n"
sleep 1.25
asdf plugin add python
asdf install python latest
echo -e "Installing scala.\n"
sleep 1.25
asdf plugin add scala https://github.com/asdf-community/asdf-scala
asdf install scala latest
echo -e "Installing nodejs.\n"
sleep 1.25
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs $NODE_LTS 
# NOTE: [nodejs] corepack enable
# NOTE: [nodejs] corepack prepare pnpm@latest --activate
# NOTE: [nodejs] asdf reshim nodejs
# NOTE: deno as an alternative:
# asdf plugin-add deno https://github.com/asdf-community/asdf-deno.git
echo -e "Installing lua.\n"
sleep 1.25
asdf plugin add lua https://github.com/Stratus3D/asdf-lua.git
asdf install lua latest
echo -e "Installing flutter.\n"
sleep 1.25
asdf plugin-add flutter
asdf install flutter latest

plugin=""
version=""
asdf list 2>&1 | while IFS= read -r line; do
    # Skip empty lines
    [[ -z $line ]] && continue
    [[ $line =~ ^[[:space:]]*No[[:space:]]versions[[:space:]]installed ]] \
	    && continue
    # If line doesn't start with space, it's a plugin name
    if [[ ! $line =~ ^[[:space:]] ]]; then
	plugin=$line
    # Anything else would be the version; since we are defining the globals
    # there will not be an asterisk and in the setup file, there would only
    # be a single version initially. Later .tool-versions are added manually.
    else
        version=$(echo $line | sed 's/^\s*//')
	echo "$plugin $version"
    ## If line has an asterisk, it's the active version
    #elif [[ "$line" =~ ^\s*\* || "$line" =~ ^\s* ]]; then
    #    # Extract version by removing leading spaces and asterisk
    #    version=$(echo $line | sed 's/^\s*\* \s*//')
    #    #version="${line#"${line%%[![:space:]]*}"}"
    #    #version="${version#\* }"
    #	echo "$current_plugin $version"
    fi
done > $HOME/.tool-versions
unset plugin
unset version
unset NODE_LTS
unset JAVA_LTS
echo -e "[${COLOR_Y}asdf-vm${RESET}]...${COLOR_G}OK${RESET}. 😎\n"


# RUSTUP
echo "➡ Setting up rustup."
read -p "Press enter to continue."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo -e "[${COLOR_Y}asdf-vm${RESET}]...${COLOR_G}OK${RESET}. 😎\n"


# DOOM EMACS
echo "➡ Cloning doomemacs into \$HOME."
read -p "Press enter to continue."
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
sudo -S dnf -y install jetbrains-mono-fonts <<< $SECRET
$HOME/.config/emacs/bin/doom install

doom_path=$HOME/.config/doom
doom_font="JetBrains Mono"
read -p "Enter email: " email
cat <<EOF >> $doom_path/config.el
;;
;; User Settings ===============================================================
(setq user-full-name "Dave Ho"
      user-mail-address "$email")

(setq doom-font (font-spec :family "$doom_font" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "$doom_font" :size 13))

(setq default-directory "~/Develop/code")
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(width . 100))
EOF
echo "⇾ Update doomemacs install nerd-fonts (M-x)."
read -p "Press enter to continue."
# :ui
sed -i 's/;;(emoji +unicode)/(emoji +unicode)/' $doom_path/init.el
sed -i 's/;;ligatures/ligatures/' $doom_path/init.el
sed -i 's/;;unicode/unicode/' $doom_path/init.el
# :editor
sed -i 's/;;parinfer/parinfer/' $doom_path/init.el
# :checkers
sed -i 's/;;(spell +flyspell)/(spell +flyspell)/' $doom_path/init.el
# :tools
sed -i 's/;;direnv/direnv/' $doom_path/init.el
sed -i 's/;;lsp/lsp/' $doom_path/init.el
# TODO: figure out tree-sitter??
# :lang
# spell +flycheck
sudo -S dnf -y install aspell <<< $SECRET
# markdown
sudo -S dnf -y install discount <<< $SECRET
sed -i 's/sh                ; /(sh +lsp)                ; /' $doom_path/init.el
# sh/bash
sudo -S dnf -y install nodejs-bash-language-server <<< $SECRET
# golang
sed -i 's/;;(go +lsp)/(go +lsp)/' $doom_path/init.el
export GOPATH="$HOME/Develop/code/golang/.gomodules"
go install github.com/x-motemen/gore/cmd/gore@latest
go install github.com/stamblerre/gocode@latest
go install golang.org/x/tools/cmd/godoc@latest
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/cmd/gorename@latest
go install github.com/cweill/gotests/gotests@latest
go install github.com/fatih/gomodifytags@latest
go install golang.org/x/tools/gopls@latest
golangci_lint_ver="v1.62.2"
# check https://golangci-lint.run/welcome/install/#local-installation for latest
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin $golangci_lint_ver
# scala
sed -i 's/;;scala/(scala +lsp)/' $doom_path/init.el
usr_bin="$HOME/Develop/usr/bin"
curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > $usr_bin/cs
chmod +x $HOME/Develop/usr/bin/cs
$HOME/Develop/usr/bin/cs install ammonite scalafmt metals
mill_ver=0.12.4
curl -L https://github.com/com-lihaoyi/mill/releases/download/$mill_ver/$mill_ver > $usr_bin/mill && chmod +x $usr_bin/mill
# clojure
sed -i 's/;;clojure/(clojure +lsp)/' $doom_path/init.el
sed -i 's/;;javascript/(javascript +lsp)/' $doom_path/init.el
sed -i 's/;;lua/(lua +lsp)/' $doom_path/init.el
sed -i 's/;;nim/nim/' $doom_path/init.el
sed -i 's/;;python/(python +lsp +pyenv)/' $doom_path/init.el
sed -i 's/;;(rust +lsp)/(rust +lsp)/' $doom_path/init.el
sed -i 's/;;web/web/' $doom_path/init.el
sed -i 's/;;json/json/' $doom_path/init.el
sed -i 's/;;yaml/yaml/' $doom_path/init.el
# TODO: installing lang+lsp dependencies.
$HOME/.config/emacs/bin/doom sync
unset doom_path
unset doom_font
unset golangci_lint_ver
unset usr_bin
# do not unset email; might be used for SSH keys below
echo -e "[${COLOR_Y}doomemacs${RESET}]...${COLOR_G}OK${RESET}. 😎\n"


# SSH Keys for Github
echo "➡ Setting up SSH keys for github."
read -p "⇾ Proceed to setup? [y/N]? " input_data 
input_data="${input_data:-N}"
if [[ "$input_data" =~ ^[Yy]$ ]]; then
    # read -p "Enter email: " email
    # use the email from doom emacs section
    ssh-keygen -t ed25519 -C $email
    if [[ -n $(eval $(ssh-agent -s)) ]]; then # (to check if running)
        ssh-add ~/.ssh/id_ed25519
        read -p "⇾ Print the public key? [y/N]? " input_data 
        input_data="${input_data:-N}"
        if [[ "$input_data" =~ ^[Yy]$ ]]; then
            cat $HOME/.ssh/id_ed25519.pub # (copy output)
            echo "⇾ Add the SSH pubkey to https://github.com/settings/keys"
	fi
	read -p "⇾ Clone and copy over .bashrc from repo? (requires SSH key) [y/N]? " input_data 
	input_data="${input_data:-N}"
        if [[ "$input_data" =~ ^[Yy]$ ]]; then
            repo="$HOME/Develop/usr/ext/github/environment"
            git clone git@github.com:imdaveho/environment.git $repo
	    cp $repo/dotfiles/dot_bashrc $HOME/.bashrc
	fi
    fi
fi
unset repo
unset email
unset input_data
echo -e "[${COLOR_Y}github ssh${RESET}]...${COLOR_G}OK${RESET}. 😎\n"


# Manual steps
echo "➡ Competing manual configuration."
echo "⇾ Settings > Privacy & Security > File History & Trash: "
echo "  • Toggle Auto Deletion [ON]"
echo "⇾ Settings > Multitasking"
echo "  • Toggle Hot Corners [OFF]"
echo "⇾ Settings > Power: "
echo "  • Screen Blank -> [15 mins]"
echo "  • Automatic Suspend -> [On Battery Power]"
echo "  • Automatic Suspend -> [45 mins]"
echo "  • Automatic Suspend > When Plugged In [OFF]"
echo "  • Show Battery Percentage [ON]"
echo "⇾ Settings > Appearance: "
echo "  • Style -> [Dark]"
echo "  • Background -> TBD"
read -p "Press enter to continue."
echo ""	
echo "⇾ Tweaks > Windows: "
echo "  • Toggle Minimize, Maximize [ON]"
echo "  • Toggle Center New Windows [ON]"
read -p "Press enter to continue."
echo ""	
echo "⇾ Extensions > Main: "
echo "  • Toggle App Menu [ON]"
read -p "Press enter to continue."
echo ""	
echo "⇾ Update Grub (if necessary): "
echo "  • Edit '/etc/default/grub' > GRUB_CMDLINE_LINUX:"
echo "    \`quiet splash\`"
echo "    (if portrait screen) \`video=DSI-1:panel_orientation=right_side_up\`"
echo "  • Regenerate grub.cfg \`grub2-mkconfig -o /boot/grub2/grub.cfg\`"
echo "  • Update \`plymouth-set-default-theme <rhgb|bgrt|spinner> -R\`"
read -p "Press enter to continue."
echo ""	
echo "⇾ Install Gnome Extensions: "
echo "  • https://extensions.gnome.org/extension/307/dash-to-dock/"
echo "  • https://extensions.gnome.org/extension/1460/vitals/"
read -p "Press enter to continue."
echo ""	
echo "⇾ Install ${COLOR_Y}keyd${RESET} for mapping ESC on BT keyboard"
echo "  • \`sudo dnf copr enable alternateved/keyd\`"
echo "  • \`sudo dnf install keyd\`"
echo "  • \`sudo mkdir /etc/keyd\`"
echo "  • update '/etc/keyd/default.conf': "
keyd_conf=$(cat << EOF
[ids]

*

[meta]

d = esc
n = esc
EOF
)
echo "$keyd_conf"
# sudo -S bash -c "tee -a /etc/keyd/default.conf <<< $keyd_conf >/dev/null" <<< $SECRET 
echo "  • \`sudo systemctl enable keyd && sudo systemctl start keyd\`"
read -p "Press enter to continue."
echo ""	
echo "⇾ Update emacs icon to doomemacs version: "
read -p "⇾ Proceed to update? [y/N]?" input_data 
input_data="${input_data:-N}"
if [[ "$input_data" =~ ^[Yy]$ ]]; then
    doom_icon_dir="$HOME/.local/share/icons/"
    mkdir -p $doom_icon_dir
    doom_icon=$doom_icon_dir"doom.png"
    # /usr/share is where dnf installs
    usr_file="/usr/share/applications/emacs.desktop"
    local_file="$HOME/.local/share/applications/emacs.desktop"
    if [[ -e $usr_file ]]; then
        cat $usr_file > $local_file
    else
        # /usr/local/share is where built emacs installs
        usr_file="/usr/local/share/applications/emacs.desktop"
        if [[ -e $usr_file ]]; then
	    cat $usr_file > $local_file
        fi
    fi

    if [[ -e $local_file ]]; then
        wget https://raw.githubusercontent.com/eccentric-j/doom-icon/master/cute-doom/doom.png -O "$doom_icon" && sudo -S --preserve-env=doom_icon,usr_file bash -c "sed -i 's|Icon=.*|Icon=$doom_icon|' $local_file" <<< $SECRET
        sudo -S gtk-update-icon-cache /usr/share/icons/* <<< $SECRET
	echo -e "[${COLOR_Y}Update doomemacs icon${RESET}]...OK. 😎\n"
    fi
else
    echo -e "Skipping ${COLOR_R}Doom emacs icon swap${RESET}.\n"
fi
unset keyd_conf
unset input_data
unset doom_icon_dir
unset doom_icon
unset usr_file
unset local_file
echo ""	
echo "=================================================="
unset SECRET
echo ""	
echo -e "${COLOR_Y}Setup complete${RESET}. 😎\n"
