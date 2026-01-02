# Kitty 配置
> [!WARNING]
> 为了终端图片绘制功能，在windows上通过WSLg实现kitty GPU功能是个坏主意，wsl2启动的UI界面总是有延迟。终端仿真器应始终运行在本机上。
1. 安装环境：
```bash
# 由于kitty需要使用GPU，需要给WSL2添加GPU支持：https://www.intel.com/content/www/us/en/docs/oneapi/installation-guide-linux/2023-0/configure-wsl-2-for-gpu-workflows.html
# 因此必须使用特定Linux发行版（ubuntu20.04 / 22.04)
proxychains wsl --install -d Ubuntu-22.04

# Step 0. add mirrors and zh_CN support
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo vim /etc/apt/sources.list
# deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
# deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
# deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
# deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse

sudo apt update
sudo apt upgrade -y

sudo apt install fonts-noto-cjk fonts-wqy-zenhei fonts-wqy-microhei
sudo apt install language-pack-zh-hans language-pack-zh-hans-base
sudo update-locale LANG=zh_CN.UTF-8
source /etc/default/locale

# Step 1. Add package repository
sudo apt-get install -y gpg-agent wget proxychains
proxychains wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | sudo gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu focal-devel main' | sudo tee  /etc/apt/sources.list.d/intel.gpu.focal.list

# Step 2. Install runtime and development (optional) packages
sudo apt-get install \
  intel-opencl-icd \
  intel-level-zero-gpu level-zero \
  intel-media-va-driver-non-free libmfx1 libmfxgen1 libvpl2 \
  libegl-mesa0 libegl1-mesa libegl1-mesa-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri \
  libglapi-mesa libgles2-mesa-dev libglx-mesa0 libigdgmm11 libxatracker2 mesa-va-drivers \
  mesa-vdpau-drivers mesa-vulkan-drivers va-driver-all

# Step 3: Configure permissions: check https://www.intel.com/content/www/us/en/docs/oneapi/installation-guide-linux/2023-0/configure-wsl-2-for-gpu-workflows.html for more

# Step 4. Verify installation
sudo apt-get install clinfo mesa-utils
clinfo
glxinfo | grep "renderer string"
# OpenGL renderer string: D3D12 (Intel(R) UHD Graphics)
```
2. 安装kitty：
```bash
proxychains wget https://sw.kovidgoyal.net/kitty/installer.sh && chmod +x ./installer.sh && proxychains ./installer.sh
echo 'export PATH="$PATH:$HOME/.local/kitty.app/bin"' > ~/.bashrc && source ~/.bashrc
sudo apt install -y xdg-desktop-portal xdg-desktop-portal-gtk libnotify-bin

# 安装字体
proxychains git clone https://github.com/ryanoasis/nerd-fonts && cd nerd-fonts/ && chmod +x ./install.sh && ./install.sh Hack && ./install.sh Noto

# 修改配置文件`~/.config/kitty/kitty.conf`，并复制背景图片到系统中

# 修复dbus报错
systemctl --user start xdg-desktop-portal.service systemctl --user start xdg-desktop-portal-gtk.service

# 修复notify报错
sudo apt install -y dunst libnotify-bin

# 预期效果：
# [0.598] Could not move child process into a systemd scope: [Errno 30] Failed to call StartTransientUnit: org.freedesktop.DBus.Error.PropertyReadOnly: Cannot set property OOMPolicy, or unknown property.
# 该报错不影响实际使用，暂不解决 
```
3. windows使用计划任务, 实现开机自启动`scripts/wsl_kitty.ps1`脚本