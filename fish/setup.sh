#!/bin/bash
# ubuntu/debian 安装fish，修改基本配置
# 个人已弃用fish
sudo apt-add-repository ppa:fish-shell/release-4
sudo apt update
sudo apt install fish
chsh -s /usr/bin/fish # 修改默认shell
fish_config theme choose 'Old School'
fish_config prompt choose disco