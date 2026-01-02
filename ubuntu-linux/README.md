# Ubuntu & Debian 配置
```bash
# 1. 安装常用工具
sudo apt update && sudo apt install -y build-essential gcc g++ make cmake autoconf automake libtool pkg-config libc6 libc6-dev libstdc++6 libssl-dev libffi-dev zlib1g zlib1g-dev wget curl git unzip net-tools libevent-dev libncurses-dev yacc

# 2. 安装常用工具
sudo apt-get install -y zsh fzf ripgrep rsync jq bat zoxide fontconfig nodejs universal-ctags nodejs npm proxychains-ng socat

# 3. 安装重要工具（由于apt版本管理滞后，部分重要软件手动安装新版）
# ohmyzsh
proxychains4 sh -c "$(proxychains4 curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# tmux
mkdir ~/tools/common && cd ~/tools/common && proxychains git clone https://github.com/tmux/tmux && cd tmux && proxychains4 sh autogen.sh && ./configure && make
sudo make install && tmux -V # tmux next-3.6
cd ~/tools/common && git clone --single-branch https://github.com/gpakosz/.tmux.git oh-my-tmux && cd oh-my-tmux
mkdir -p ~/.config/tmux
ln -s ${PWD}/.tmux.conf ~/.config/tmux/tmux.conf 
cp ${PWD}/.tmux.conf.local ~/.config/tmux/tmux.conf.local
mkdir -p ~/.tmux/plugins && cd ~/.tmux/plugins && proxychains git clone 'https://github.com/tmux-plugins/tmux-copycat' && proxychains git clone 'https://github.com/tmux-plugins/tmux-cpu' && proxychains git clone 'https://github.com/tmux-plugins/tmux-resurrect' && proxychains git clone 'https://github.com/aserowy/tmux.nvim'

# pyenv
proxychains4 curl -fsSL https://pyenv.run | proxychains4 bash
source ~/.zshrc && proxychains pyenv install 3.13.6 && pyenv global 3.13.6

# rust
proxychains4 curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | proxychains4 sh

# neovim
cd ~/tools/common && proxychains wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz && tar -xvzf nvim-linux-x86_64.tar.gz && rm nvim-linux-x86_64.tar.gz
cd ~/tools/common/nvim-linux-x86_64/bin/ && echo 'export PATH='${PWD}':$PATH' >> ~/.zshrc
source ~/.zshrc


# Docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo proxychains apt-get update
sudo proxychains apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker 代理：使用privoxy将socks5代理转http
sudo apt install -y privoxy
echo 'forward-socks5t / user:pass@127.0.0.1:1080 .' | sudo tee -a /etc/privoxy/config
sudo systemctl restart privoxy
sudo mkdir -p /etc/systemd/system/docker.service.d

sudo tee /etc/systemd/system/docker.service.d/proxy.conf > /dev/null <<EOF
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


# FossFlow
mkdir -p ~/tools/common/fossflow && cd ~/tools/common/fossflow && proxychains git clone https://github.com/stan-smith/FossFLOW && cd FossFLOW
sudo docker run -p 7080:80 -v $(pwd)/diagrams:/data/diagrams stnsmith/fossflow:latest

# 4. 更新配置
cd ~/tools/common && proxychains4 git clone https://github.com/Ky9oss/DarkArch && cd DarkArch
cp ./ohmyzsh/.zshrc ~/.zshrc && cd ~/tools/common/nvim-linux-x86_64/bin/ && echo 'export PATH='${PWD}':$PATH' >> ~/.zshrc
cp ./tmux/tmux.conf.local ~/.config/tmux/tmux.conf.local
cp -r ./nvim ~/.config/nvim
```