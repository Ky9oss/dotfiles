# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="clean"

# ohmyzsh plugins 
# proxychains git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
# proxychains git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# proxychains git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-vi-mode) # zsh-vi-mode
source $ZSH/oh-my-zsh.sh

# zoxide
eval "$(zoxide init zsh)"

# Openai

# Rust
. "$HOME/.cargo/env"
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# tmux
export EDITOR="/usr/sbin/nvim"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# cargo installation
# export CARGO_TARGET_DIR="/root/tools/runtime/default_cargo_target"
export CARGO_TARGET_DIR="./"

# PATH
export PATH=$PATH:"/root/tools/runtime/default_cargo_target"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# luarocks
export LUA_PATH="/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;;"
export LUA_CPATH="/usr/lib/lua/5.1/?.so;;"

# pnpm
export PNPM_HOME="/root/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# nvim alais
alias v='nvim'
nvim() {
  if [[ $# -eq 0 ]]; then
    # 没有参数，直接打开 nvim
    command nvim
  else
    local target=$1
    if [[ -d $target ]]; then
      # 参数是目录
      cd "$target" && command nvim
    elif [[ -f $target ]]; then
      # 参数是文件
      local dir=$(dirname "$target")
      local file=$(basename "$target")
      cd "$dir" && command nvim "$file"
    else
      # 不是文件也不是目录，直接交给 nvim 处理
      command nvim "$target"
    fi
  fi
}


