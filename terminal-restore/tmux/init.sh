#!/bin/bash
# 
# Description: Init my configure on tmux
# Author: Ky9oss

# Install tmp and oh-my-tmux
mkdir -p ~/.tmux/plugins/tpm && proxychains git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cd ~/tools/common && git clone --single-branch https://github.com/gpakosz/.tmux.git oh-my-tmux && cd oh-my-tmux
mkdir -p ~/.config/tmux
ln -s ${PWD}/.tmux.conf ~/.config/tmux/tmux.conf 
cp ${PWD}/.tmux.conf.local ~/.config/tmux/tmux.conf.local

# If plugin installed failed due to network issues, we should download them manually.
#
# Eidt ~/.config/tmux/tmux.conf.local: 
# tmux_conf_update_plugins_on_launch=false
# tmux_conf_update_plugins_on_reload=false
# tmux_conf_uninstall_plugins_on_reload=false
#
# proxychains git clone 'https://github.com/tmux-plugins/tmux-copycat'
# proxychains git clone 'https://github.com/tmux-plugins/tmux-cpu'
# proxychains git clone 'https://github.com/tmux-plugins/tmux-resurrect'
# proxychains git clone 'https://github.com/aserowy/tmux.nvim'
