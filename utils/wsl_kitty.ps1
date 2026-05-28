# 该脚本用于windows中从wsl自启动kitty
# 
# 以下脚本添加到windows计划任务中
Start-Process "wsl.exe" -WindowStyle Hidden
Start-Process "ubuntu2204.exe" " run bash -c '~/.local/kitty.app/bin/kitty --detach'" -WindowStyle Hidden

# 如果常规安装出错，可以选择手动安装方式：
# 1. 安装`archlinux-xxx.wsl`文件：[https://mirrors.aliyun.com/archlinux/wsl/latest/?spm=a2c6h.25603864.0.0.3b896e31D6YFPc]
# 2. `wsl --install --from-file xxx.wsl`安装Arch
#
# 重点配置如下：
# - 确保使用Mirrored mode networking而不是NAT或桥接模式
