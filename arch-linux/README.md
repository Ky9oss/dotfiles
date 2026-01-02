# Arch基本配置
1. 添加国内镜像：`sh -c 'echo -e "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch\nServer = https://mirrors.aliyun.com/archlinux/\$repo/os/\$arch\nServer = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch\nServer = https://mirror.sjtu.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist'`
2. 更新系统：`pacman -Syu`
3. update repo: `pacman -Syy`
3. 安装基本工具：`pacman -S --needed base-devel git curl wget unzip zip gdb lib32-glibc lib32-gcc-libs net-tools openssh`
4. 安装常用工具：`pacman -S zsh fzf ripgrep rsync fd jq bat vim neovim tmux proxychains-ng zoxide fontconfig nodejs universal-ctags nodejs npm openssh `
5. `proxychains`添加代理：`nvim /etc/proxychains.conf`
6. 安装`ohmyzsh`:`proxychains sh -c "$(proxychains curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
7. 修改`.zshrc`文件（参考该项目的`.zshrc`）
8. 修改`/etc/locale.gen`，解注释：`en_US.UTF-8 UTF-8`, 运行`locale-gen`  

### 开启`github`权限

```bash
git config --global credential.helper store
git config --system credential.helper store

# 从Github 获取Access Token，开启repo权限
# git push时，要求填写密码。密码填写为Acsess Token即可
```

### （可选）安装paru
```sh
# 创建新用户
useradd -m builduser
passwd builduser

# 添加用户到sudoer
usermod -aG wheel builduser
visudo # 去掉注释 %wheel ALL=(ALL:ALL) ALL
su builduser
cd

# 安装paru
proxychains git clone https://aur.archlinux.org/paru.git
cd paru
proxychains makepkg -s
su root
pacman -U /home/builduser/paru/paru-2.1.0-1-x86_64.pkg.tar.zst
```