# 编程语言环境部署

### rust
1. 安装环境：`proxychains curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

### python
1. install pyenv: `proxychains curl -fsSL https://pyenv.run | proxychains bash`
2. add pyenv startup env: 
```sh
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init - zsh)"' >> ~/.zshrc
```
3. `source ~/.zshrc`
4. `proxychains pyenv install 3.13.6`
5. `pyenv global 3.13.6`
6. install uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`

### asm
1. `proxychains wget --secure-protocol=tlsv1_2 --no-check-certificate https://github.com/bergercookie/asm-lsp/releases/download/v0.10.0/asm-lsp-x86_64-unknown-linux-gnu.tar.gz`
2. `tar -zxvf asm-lsp-x86_64-unknown-linux-gnu.tar.gz`
3. add asm-lsp in $PATH

### java
1. `curl -s "https://get.sdkman.io" | bash`
2. `source "$HOME/.sdkman/bin/sdkman-init.sh"`
3. `sdk use java 21.0.8-amzn`
4. `sdk default java 21.0.8-amzn`

### dotnet
1. `pacman -S dotnet-sdk`
2. `dotnet tool install -g EasyDotnet`