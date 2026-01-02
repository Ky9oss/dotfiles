#!/bin/bash
# 手动安装ohmyzsh插件，避免自动安装报错
mkdir -p ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
proxychains git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
proxychains git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
proxychains git clone https://github.com/jeffreytse/zsh-vi-mode.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
source ~/.zshrc