# 该脚本用于windows中从wsl自启动kitty
# 
# 以下脚本添加到windows计划任务中
Start-Process "wsl.exe" -WindowStyle Hidden
Start-Process "ubuntu2204.exe" " run bash -c '~/.local/kitty.app/bin/kitty --detach'" -WindowStyle Hidden