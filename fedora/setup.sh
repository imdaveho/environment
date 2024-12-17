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
read -sp "➡ Store password: " SECRET
echo -e "[${COLOR_Y}Storing password${RESET}]...OK. 😎\n"

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
echo -e "[${COLOR_Y}Optimizing DNF${RESET}]...OK. 😎\n"

# Install RPM Fusion
echo "➡ Installing RPM Fusion repos."
mirror="https://mirrors.rpmfusion.org/free/fedora/\
    rpmfusion-free-release-$(rpm -e %fedora).noarch.rpm"
sudo -S dnf -y install $mirror <<< $SECRET
mirror="https://mirrors.rpmfusion.org/nonfree/fedora/\
    rpmfusion-nonfree-release-$(rpm -e %fedora).noarch.rpm"
sudo -S dnf -y install $mirror <<< $SECRET
unset mirror
echo -e "[${COLOR_Y}Installing RPM Fusion repos${RESET}]...OK. 😎\n"

# Set hostname
echo "➡ Update the hostname."
read -p "Enter hostname: " hostname
hostnamectl set-hostname "$hostname"
unset hostname
echo -e "[${COLOR_Y}Updating hostname${RESET}]...OK. 😎\n"

# Getting proper media playback
echo "➡ Setting up proper media codecs."
# Switch to full FFMPEG.
sudo -S dnf -y swap 'ffmpeg-free' 'ffmpeg' --allowerasing 
sudo -S dnf4 -y group upgrade multimedia
# Installs gstreamer components. 
# Required if you use Gnome Videos and other dependent applications.
sudo -S dnf -y update @multimedia --setopt="install_weak_deps=False" \
    --exclude=PackageKit-gstreamer-plugin
# Installs useful Sound and Video complement packages.
sudo -S dnf -y update @sound-and-video 
echo -e "[${COLOR_Y}Setting proper media codecs${RESET}]...OK. 😎\n"

# Update the system
echo "➡ Updating the system."
sudo -S dnf group upgrade -y core <<< $SECRET
sudo -S dnf4 group update -y core <<< $SECRET
sudo -S dnf -y update @core <<< $SECRET
sudo -S dnf -y update <<< $SECRET
echo -e "[${COLOR_Y}Updating the system${RESET}]...OK. 😎\n"


# Install necessary things
echo "➡ Removing unneeded apps, packages, and libraries."
sudo -S dnf -y remove libreoffice* firefox <<< $SECRET
sudo -S dnf group remove -y libreoffice <<< $SECRET
echo "➡ Installing default apps, packages, and libraries."
flatpak remote-add --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo

echo "[flathub, zen, gnome-extensions, flatseal, neovim, gnome-tweaks, \
    intel-media-driver, vlc, *python-build-dependencies]"

flatpak install flathub \
    io.github.zen_browser.zen \
    org.gnome.Extensions \
    com.github.tchx84.Flatseal \
    md.obsidian.Obsidian

sudo -S dnf -y install neovim gnome-tweaks vlc intel-media-driver <<< $SECRET
echo "➡ Installing Python build dependencies."
read -p "⇾ Proceed to install? [Y/n]?" input_data 
input_data="${input_data:-Y}"

if [[ "$input_data" =~ ^[Yy]$ ]]; then
    python_build_deps="make gcc patch zlib-devel bzip2 bzip2-devel \
	readline-devel sqlite sqlite-devel openssl-devel tk-devel \
	libffi-devel xz-devel libuuid-devel gdbm-libs libnsl2"
    sudo -S dnf -y install "$python_build_deps" <<< $SECRET
else
    echo -e "Skipping installation of \
	${COLOR_R}python build dependencies${RESET}.\n"
fi

echo "➡ Installing Emacs build dependencies."
read -p "⇾ Proceed to install? [Y/n]?" input_data 
input_data="${input_data:-Y}"

if [[ "$input_data" =~ ^[Yy]$ ]]; then
    emacs_build_deps="gcc make autoconf texinfo gnutls-devel \
	libxml2-devel ncurses-devel gtk3-devel"
    sudo -S dnf -y install "$emacs_build_deps" <<< $SECRET
else
    echo -e "Skipping installation of \
	${COLOR_R}Emacs build dependencies${RESET}.\n"
    # TODO: install distro emacs from DNF
fi
unset python_build_deps
unset emacs_build_deps
unset input_data
echo -e "[${COLOR_Y}Installing core packages${RESET}]...OK. 😎\n"

# Setting up CodeWeavers CrossOver
echo "➡ Setting up CrossOver."
read -p "⇾ Proceed to setup? [y/N]?" input_data 
input_data="${input_data:-N}"
if [[ "$input_data" =~ ^[Yy]$ ]]; then
    sudo -S dnf -y install \
	    https://crossover.codeweavers.com/redirect/crossover.rpm \
	    <<< $SECRET
    echo "Installed CrossOver. Attempting to register."
    read -p "⇾ Ready to register? \
	This requires the CodeWeavers account password. [n/Y]?" input_data 
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
echo -e "[${COLOR_Y}Installing CrossOver${RESET}]...OK. 😎\n"

# Setting up development directories
mkdir -p $HOME/Develop/build $HOME/Develop/usr
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
)
for $lang in "${langauges[@]}"; do
    mkdir $HOME/Develop/build/$line
done
unset languages
mkdir $HOME/Develop/usr/repo $HOME/Develop/usr/bin
git clone https://github.com/imdaveho/environment \
    $HOME/Develop/usr/repo/environment
sudo -S dnf -y install eza direnv ripgrep findutils fd <<< $SECRET
# TODO: configure asdf-vm
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
# installing java python golang nim clojure node scala
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
# [golang] set GOPATH.../Develop/build/golang/.gomod
# [golang] set GOROOT?
asdf plugin-add java https://github.com/halcyon/asdf-java.git
# [clojure] sudo dnf install rlwrap
asdf plugin add clojure https://github.com/asdf-community/asdf-clojure.git
asdf plugin add nim # install the asdf-nim plugin
asdf nim install-deps  # install system-specific dependencies for downloading & building Nim
asdf plugin-add python
asdf plugin add scala https://github.com/asdf-community/asdf-scala
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
# [nodejs] corepack enable
# [nodejs] corepack prepare pnpm@latest --activate
# [nodejs] asdf reshim nodejs
asdf plugin-add lua https://github.com/Stratus3D/asdf-lua.git
# [rust]
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# TODO: installing all the LSP crap...maybe move to separate shell script?
# TODO: configure doom emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# TODO: installing rust/rustup
# TODO: setting up GPG keys for github?
# ssh-keygen -t ed25519 -C "your_email@example.com"
# eval "$(ssh-agent -s)" # (to check if running)
# ssh-add ~/.ssh/id_ed25519
# cat ~/.ssh/id_ed25519.pub # (copy output)
# add new SSH key in https://github.com/settings/keys
# TODO: dnf install jetbrains-mono-fonts and nerd fonts

# Manual steps
echo "➡ Competing manual configuration."
echo "⇾ Settings > Privacy & Security > File History & Trash: "
echo "  • Toggle Auto Deletion [ON]"
read -p "Press [enter] to move on."
echo ""	
echo "⇾ Tweaks > Windows: "
echo "  • Toggle Minimize, Maximize [ON]"
echo "  • Toggle Center New Windows [ON]"
read -p "Press [enter] to move on."
echo ""	
echo "⇾ Extensions > Main: "
echo "  • Toggle App Menu [ON]"
read -p "Press [enter] to move on."
echo ""	
echo "⇾ Update Grub (if necessary): "
echo "  • Edit '/etc/default/grub' > GRUB_CMDLINE_LINUX:"
echo "    \`quiet splash\`"
echo "    (if portrait screen) \`video=DSI-1:panel_orientation=right_side_up\`"
echo "  • Regenerate grub.cfg \`grub2-mkconfig -o /boot/grub2/grub.cfg\`"
echo "  • Update \`plymouth-set-default-theme <bgrt|spinner> -R\`"
read -p "Press [enter] to move on."
echo ""	
echo "⇾ Install Gnome Extensions: "
echo "  • https://extensions.gnome.org/extension/307/dash-to-dock/"
echo "  • https://extensions.gnome.org/extension/1460/vitals/"
read -p "Press [enter] to move on."
echo ""	
echo "⇾ Install ${COLOR_Y}keyd${RESET} for mapping ESC on BT keyboard"
echo "  • \`sudo dnf copr enable alternateved/keyd\`"
echo "  • \`sudo dnf install keyd\`"
echo "  • update '/etc/keyd/default.conf': "
keyd_conf=$(cat << EOF
     | [ids]
     |
     | *
     |
     | [meta]
     |
     | d = esc
     | n = esc
EOF
)
echo "$keyd_conf"
echo "  • \`sudo systemctl enable keyd && start keyd\`"
read -p "Press [enter] to move on."
echo ""	
echo "⇾ Update emacs icon to doomemacs version: "
read -p "⇾ Proceed to update? [y/N]?" input_data 
input_data="${input_data:-N}"
if [[ "$input_data" =~ ^[Yy]$ ]]; then
    doom_icon="$HOME/.local/share/icons/doom.png"
    usr_file="/usr/share/applications/emacs.desktop"
    local_file="$HOME/.local/share/applications/emacs.desktop"
    cat $desktop_file > $local_file
    wget https://raw.githubusercontent.com/eccentric-j/doom-icon/master/\
	cute-doom/doom.png -O "$doom_icon" &&
    sudo -S --preserve-env=doom_icon,desktop_file \
        bash -c "sed -i 's|Icon=.*|Icon=$icon|' $local_file" <<< $SECRET
    sudo -S gtk-update-icon-cache /usr/share/icons/* <<< $SECRET
else
    echo -e "Skipping ${COLOR_R}Doom emacs icon swap${RESET}.\n"
fi
unset keyd_conf
unset input_data
unset doom_icon
unset desktop_file
echo ""	
echo -e "[${COLOR_Y}Wrapping up manual steps${RESET}]...OK. 😎\n"
echo "=================================================="
unset SECRET
echo -e "Setup complete.\n"
