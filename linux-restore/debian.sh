#!/bin/bash
#
# Restore development environment in Debian-based distro such as debian, ubuntu, kali.
# By Ky9oss

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOWNLOAD_SH="$CURRENT_DIR/utils/download.sh"
source "$DOWNLOAD_SH"

TARGET_DIR="$HOME/tools/"

INSTALL_BASIC_LIBS=1
INSTALL_RUST=1
INSTALL_RADARE2=1
INSTALL_VIRTULBOX_LIBS=1

#######################################
# Confirm next command.
# Globals:
#   None
# Arguments:
#   $1: desc
#   $@: command
#######################################
confirm() {
    local desc="${1:continue}"
    echo "${desc}"
    shift 1
    "$@"
}

setup_install() {

    mkdir -p ~/tools
    apt-get update
    sudo usermod -aG sudo "$USER"

    # proxychains-ng
    sudo apt-get -y install proxychains-ng
    sudo sed -i '/^\[ProxyList\]/,/^$/d' /etc/proxychains4.conf
    sudo tee -a /etc/proxychains4.conf <<'EOF'
[ProxyList]
socks5 ip port user pass

EOF
    proxychains4 -q curl https://www.google.com # Return: Google Search

    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo tee /etc/apt/sources.list <<'EOF'
# Debian 13 trixie - tuna
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-backports main contrib non-free non-free-firmware
deb https://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware

EOF
    sudo proxychains apt update

    # never sleep or suspend
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target

    # TODO: check current env is Virtulbox or else
    sudo sh /media/cdrom0/VBoxLinuxAdditions.run

}

install_basic_libs() {
    apt install -y build-essential dkms linux-headers-$(uname -r) perl make gcc g++ make cmake autoconf automake libtool pkg-config libc6 libc6-dev libstdc++6 libssl-dev libffi-dev zlib1g zlib1g-dev wget curl git unzip net-tools libevent-dev libncurses-dev yacc gcc-multilib g++-multilib libc6-dev-i386 libcurl4-openssl-dev libpam-wtmpdb
    apt install -y vim curl wget net-tools lsof htop
    apt-get install -y gdb zsh fzf ripgrep rsync jq bat zoxide fontconfig nodejs universal-ctags npm socat

    # docs
    apt install -y manpages manpages-dev gcc-doc cpp-doc

    # git
    git config --global core.autocrlf false
    git config --global credential.helper store
}


install_tmux() {
    # tmux
    cd ~/tools && proxychains4 git clone https://github.com/tmux/tmux && cd tmux && proxychains4 sh autogen.sh && ./configure && make
    # [Error]
    # fatal: unable to access 'https://github.com/tmux/tmux/': Failed to connect to github.com port 443 after 1 ms: Couldn't connect to server
    sudo make install && tmux -V # tmux next-3.6
    cd ~/tools && proxychains4 git clone --single-branch https://github.com/gpakosz/.tmux.git oh-my-tmux && cd ~/tools/oh-my-tmux
    mkdir -p ~/.config/tmux
    ln -s -f "${PWD}"/.tmux.conf ~/.config/tmux/tmux.conf
    cp "${PWD}"/.tmux.conf.local ~/.config/tmux/tmux.conf.local
    mkdir -p ~/.tmux/plugins && cd ~/.tmux/plugins && proxychains4 git clone 'https://github.com/tmux-plugins/tmux-copycat' && proxychains4 git clone 'https://github.com/tmux-plugins/tmux-cpu' && proxychains4 git clone 'https://github.com/tmux-plugins/tmux-resurrect' && proxychains4 git clone 'https://github.com/aserowy/tmux.nvim'

    proxychains4 -q wget https://raw.githubusercontent.com/Ky9oss/Encore.sh/refs/heads/main/tmux.conf.local -O ~/.config/tmux/tmux.conf.local

}

install_ohmyzsh() {
    # ohmyzsh
    proxychains4 -q sh -c "$(proxychains4 -q wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # Time to change your default shell to zsh:
    # Do you want to change your default shell to zsh? [Y/n]
    mkdir -p ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
    proxychains4 git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    proxychains4 git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    # proxychains4 git clone https://github.com/jeffreytse/zsh-vi-mode.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
    sudo tee ~/.zshrc <<'EOF'
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="clean"

# ohmyzsh plugins 
plugins=(git zsh-syntax-highlighting zsh-autosuggestions) # zsh-vi-mode
source $ZSH/oh-my-zsh.sh

# zoxide
eval "$(zoxide init zsh)"

# vim-mode
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[1 q'
  else
    echo -ne '\e[5 q'
  fi
}

function zle-line-init {
  echo -ne '\e[5 q'
}

zle -N zle-keymap-select
zle -N zle-line-init

EOF
    source ~/.zshrc
}

install_python_dev() {

    # python - pyenv
    sudo apt install -y build-essential zlib1g-dev libffi-dev libssl-dev \
        libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev \
        libncursesw5-dev tk-dev libgdbm-dev libdb-dev \
        uuid-dev
    proxychains4 -q curl https://pyenv.run | proxychains4 -q sh
    sudo tee -a ~/.zshrc <<'EOF'
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

EOF
    source ~/.zshrc && proxychains -q pyenv update && proxychains4 -q pyenv install 3.14.0 && pyenv global 3.14.0

}

install_rust_dev() {
    # rust
    proxychains4 -q curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | proxychains4 -q sh
    # 1) Proceed with standard installation (default - just press enter)
    # 2) Customize installation
    # 3) Cancel installation
    # >
    sudo tee -a ~/.zshrc <<'EOF'
# Rust
. "$HOME/.cargo/env"
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
export CARGO_TARGET_DIR="./"

EOF
    source ~/.zshrc

}

install_lua_dev() {
    # lua
    cd tools && proxychains -q wget https://www.lua.org/ftp/lua-5.5.0.tar.gz && tar -zxvf lua-5.5.0.tar.gz && cd lua-5.5.0 && make all test && sudo make install
    cd ~/tools && proxychains4 -q git clone https://luajit.org/git/luajit.git
    cd ~/tools/luajit && make && sudo make install
    cd ~/tools && proxychains4 -q wget https://luarocks.org/releases/luarocks-3.13.0.tar.gz && tar zxpf luarocks-3.13.0.tar.gz
    cd ~/tools/luarocks-3.13.0 && ./configure && make && sudo make install
    mkdir ~/tools/lua_ls && cd ~/tools/lua_ls && proxychains4 -q wget https://github.com/LuaLS/lua-language-server/releases/download/3.17.1/lua-language-server-3.17.1-linux-x64.tar.gz && tar -zxvf lua-language-server-3.17.1-linux-x64.tar.gz
    sudo tee -a ~/.zshrc <<'EOF'
export PATH=~/tools/lua_ls/bin:$PATH

EOF
    # need rust
    cargo install stylua --features luajit
    source ~/.zshrc

}

install_cpp_dev() {
    # c/cpp
    sudo apt-get install clang-format
    cd ~/tools/bin && proxychains4 wget https://github.com/ninja-build/ninja/releases/download/v1.13.2/ninja-linux.zip && unzip ninja-linux.zip
    proxychains wget https://github.com/mesonbuild/meson/releases/download/1.10.1/meson-1.10.1.tar.gz && tar -zxf meson-1.10.1.tar.gz && cd meson-1.10.1 && ln -s meson.py meson
    sudo tee -a ~/.zshrc <<'EOF'
export PATH=~/tools/bin:$PATH
export PATH=~/tools/meson-1.10.1:$PATH

EOF

    # new gcc/g++
    sudo proxychains apt install -t sid gcc-15 g++-15
}

install_kvm() {
    # kvm
    sudo apt install cpu-checker qemu-kvm libvirt-clients libvirt-daemon-system virt-manager -y
    # kvm check
    sudo virt-host-validate qemu
}

install_bash_dev() {
    # bash
    sudo apt install shellcheck bats
}

reverse_engineer_setup() {
    # mutiple versions of glibc
    mkdir -p ~/tools/glibc
    proxychains wget https://ftp.gnu.org/gnu/glibc/glibc-2.38.tar.xz
    tar xf glibc-2.38.tar.xz
    cd glibc-2.38
    mkdir build && cd build
    ../configure --prefix=$HOME/tools/glibc/glibc-2.38 \
        --disable-profile --enable-add-ons \
        --with-headers=/usr/include # 通常用系统头文件
    make -j$(nproc)
    make install
    cd ../../ && rm -rf glibc-2.38

    # TODO: gef+gdb
}

web_hacker_setup() {
    # rockyou
    mkdir ~/tools/wordlists && cd ~/tools/wordlists && proxychains4 -q git clone https://github.com/zacheller/rockyou && cd rockyou && tar -zxvf ./rockyou.txt.tar.gz
}

malware_developer_setup() {
    whoami
}

install_docker() {
    # Docker
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo proxychains apt-get update
    sudo proxychains apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Docker 代理：使用privoxy将socks5代理转http
    sudo apt install -y privoxy
    echo 'forward-socks5t / user:pass@127.0.0.1:1080 .' | sudo tee -a /etc/privoxy/config
    sudo systemctl restart privoxy
    sudo mkdir -p /etc/systemd/system/docker.service.d

    sudo tee /etc/systemd/system/docker.service.d/proxy.conf >/dev/null <<EOF
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:8118"
Environment="HTTPS_PROXY=https://127.0.0.1:8118"
Environment="NO_PROXY=localhost,127.0.0.1"
EOF

    sudo systemctl daemon-reexec
    sudo systemctl restart docker
    sudo docker run hello-world
    # 如果遇到docker compose，需要修改compose.yml文件来添加proxy：
    #    environment:
    #      - HTTP_PROXY=http://127.0.0.1:8118
    #      - HTTPS_PROXY=https://127.0.0.1:8118
    #      - NO_PROXY=localhost,127.0.0.1

    # Cross compilation
    sudo apt install -y gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 mingw-w64-tools

    # wine and wine-msvc
    sudo mkdir -pm755 /etc/apt/keyrings
    proxychains wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
    sudo dpkg --add-architecture i386
    sudo apt-get install -y wine64 msitools winbind
    cd ~/tools && proxychains git clone https://github.com/mstorsjo/msvc-wine && cd msvc-wine
    mkdir -p ~/my_msvc/opt/msvc && ./vsdownload.py --dest ~/my_msvc/opt/msvc && ./install.sh ~/my_msvc/opt/msvc
}

install_gitlab() {
    whoami
}

install_utils() {
    sudo ln -s "$(pwd)/utils/download.sh" /bin/download

}

install_neovim() {
    # nvim
    download "https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.tar.gz"

    sudo tee -a ~/.zshrc <<'EOF'
# nvim
export EDITOR="/usr/sbin/nvim"
export MANPAGER='nvim +Man!'
export PATH=~/tools/nvim-linux-x86_64/bin:$PATH
export PATH=~/.local/share/nvim/mason/bin:$PATH

EOF
    cd ~/tools/nvim-linux-x86_64/bin/nvim && sudo ln -s ./nvim /usr/sbin/nvim

    # spectervim
    mv ~/.config/nvim ~/.config/nvim_bak
    proxychains -q git clone https://github.com/Ky9oss/SpecterVim ~/.config/nvim
    source ~/.zshrc

    # lib: sshpass
    cd ~/tools/ && proxychains4 -q git clone https://github.com/kevinburke/sshpass.git && cd sshpass && ./configure && sudo make && sudo make install
}

install_radare2() {
    proxychains4 -q git clone https://github.com/radareorg/radare2
    chmod +x radare2/sys/install.sh
    proxychains4 -q radare2/sys/install.sh
    proxychains r2pm -U
    proxychains r2pm install r2dec
}

install_re_basics() {

    sudo apt install strace ltrace patchelf xxd
}

install_autotools() {

    # libtool
    proxychains git clone git://git.savannah.gnu.org/libtool.git
    cd libtool || exit
    sudo apt-get install help2man texinfo
    ./bootstrap
    ./configure && make
    sudo make install

}

main() {

    if [[ -e "$TARGET_DIR" ]]; then
        mkdir -p "$TARGET_DIR"
    fi

    cd "$TARGET_DIR" || exit
}
