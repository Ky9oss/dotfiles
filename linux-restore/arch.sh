#!/bin/bash
# 
# Description: Resotre my dev env in arch linux.
# Author: Ky9oss

# Add mirrors
sh -c 'echo -e "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch\nServer = https://mirrors.aliyun.com/archlinux/\$repo/os/\$arch\nServer = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch\nServer = https://mirror.sjtu.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist'
pacman -Syu
pacman -Syy
pacman -S --needed base-devel git curl wget unzip zip gdb lib32-glibc lib32-gcc-libs net-tools openssh
pacman -S zsh fzf ripgrep rsync fd jq bat vim neovim tmux proxychains-ng zoxide fontconfig nodejs universal-ctags nodejs npm openssh
nvim /etc/proxychains.conf
proxychains sh -c "$(proxychains curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# edit .zshrc
# edit /etc/locale.gen -- Remove comments: en_US.UTF-8 UTF-8
locale-gen

# Get github access
git config --global credential.helper store
git config --system credential.helper store

# Get Access Token from Github
# git push: add Access Token as password

# paru(optional)
useradd -m builduser
passwd builduser
usermod -aG wheel builduser # add user to sudoer
visudo # Remove comments:  %wheel ALL=(ALL:ALL) ALL
su builduser
cd
proxychains git clone https://aur.archlinux.org/paru.git
cd paru
proxychains makepkg -s
su root
pacman -U /home/builduser/paru/paru-2.1.0-1-x86_64.pkg.tar.zst
