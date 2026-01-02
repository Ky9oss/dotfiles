# Tmux 配置
1. 安装`tpm`：`mkdir -p ~/.tmux/plugins/tpm && proxychains git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
2. 安装`oh-my-tmux`，随后修改`~/.config/tmux/tmux.conf.local`,参考项目文件`tmux.conf.local`
```sh
cd ~/tools/common && git clone --single-branch https://github.com/gpakosz/.tmux.git oh-my-tmux && cd oh-my-tmux
mkdir -p ~/.config/tmux
ln -s ${PWD}/.tmux.conf ~/.config/tmux/tmux.conf 
cp ${PWD}/.tmux.conf.local ~/.config/tmux/tmux.conf.local
mkdir -p ~/.tmux/plugins && cd ~/.tmux/plugins && proxychains git clone 'https://github.com/tmux-plugins/tmux-copycat' && proxychains git clone 'https://github.com/tmux-plugins/tmux-cpu' && proxychains git clone 'https://github.com/tmux-plugins/tmux-resurrect' && proxychains git clone 'https://github.com/aserowy/tmux.nvim'
```

### 常见错误
1. 由于代理问题，oh-my-tmux使用tpm自动安装插件可能会失败。
#### 解决方法
在`~/.config/tmux/tmux.conf.local`中, 修改以下三个配置为`false`
```conf
tmux_conf_update_plugins_on_launch=false
tmux_conf_update_plugins_on_reload=false
tmux_conf_uninstall_plugins_on_reload=false
```

在`~/.tmux/plugins`目录下，执行：
```bash
proxychains git clone 'https://github.com/tmux-plugins/tmux-copycat'
proxychains git clone 'https://github.com/tmux-plugins/tmux-cpu'
proxychains git clone 'https://github.com/tmux-plugins/tmux-resurrect'
proxychains git clone 'https://github.com/aserowy/tmux.nvim'
```