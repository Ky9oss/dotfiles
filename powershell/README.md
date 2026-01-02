# Windows
## Powershell 配置
管理员运行powershell：
```ps1
# 更新powershell NuGet
Install-Module -Name PowerShellGet -Force; exit

Install-Module PSReadLine -Repository PSGallery -Scope CurrentUser -Force
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
# 追加oh-my-posh到env $env:Path += ";C:\Users\user\AppData\Local\Programs\oh-my-posh\bin"
oh-my-posh init powershell --config 'atomic' | Out-File -FilePath $PROFILE -Append -Encoding utf8
Install-Script -Name Refresh-EnvironmentVariables -RequiredVersion 1.0.1
[System.Environment]::SetEnvironmentVariable("POWERSHELL_SCRIPTS", "C:\Program Files\WindowsPowerShell\Scripts", [System.EnvironmentVariableTarget]::User)

# 下面是pyenv-win & pyenv-win-venv的安装（不建议使用，两个工具之间的交互有问题，我搞了半天没弄好）
# windows里建议anaconda，linux里建议pyenv
[System.Environment]::SetEnvironmentVariable("DRUNTIME", "<your-path>", "MACHINE")
proxychains git clone https://github.com/pyenv-win/pyenv-win.git $env:DRUNTIME
[System.Environment]::SetEnvironmentVariable("PYENV", "$env:DRUNTIME\pyenv-win", "MACHINE")
[System.Environment]::SetEnvironmentVariable( `
  "PATH", `
  "$env:PYENV\pyenv-win\bin;$env:PYENV\pyenv-win\shims;$([System.Environment]::GetEnvironmentVariable('PATH','MACHINE'))", `
  "MACHINE" `
)
proxychains git clone https://github.com/pyenv-win/pyenv-win-venv "$env:DRUNTIME\.pyenv-win-venv"
[System.Environment]::SetEnvironmentVariable( `
  "PATH", `
  "$env:DRUNTIME\.pyenv-win-venv\bin;$([System.Environment]::GetEnvironmentVariable('PATH','MACHINE'))", `
  "MACHINE" `
)

# install zoxide
cargo install zoxide --locked
echo 'Invoke-Expression (& { (zoxide init powershell | Out-String) })' | Out-File -FilePath $PROFILE -Append -Encoding utf8
```

## Windows OpenSSH Server
修改配置文件`C:\ProgramData\ssh\sshd_config`:
```
Port <your_port>
ListenAddress 127.0.0.1
PubkeyAuthentication yes
AuthorizedKeysFile	.ssh/authorized_keys
```
> [!CAUTION] 坑点
> 1. `~/.ssh` `~/.ssh/authorized_keys` 两个文件的权限很容易造成ssh公私钥认证失败。使用`https://github.com/PowerShell/Win32-OpenSSH`所提供的脚本`FixHostFilePermission.ps1`可以解决问题。
> 2. `~/.ssh/authorized_keys`手动复制公钥时可能会因为CRLF格式添加额外的`\r`，可以通过`cat -A xxx`来查看文件里是否有`^M`, 如果有则使用`dos2unix`删除：`dos2unix /mnt/c/Users/<User>/.ssh/authorized_keys`
> 3. OpenSSH新版中的公私钥默认格式为`OpenSSH`格式，使用`ssh-keygen -t rsa -m PEM -f ~/.ssh/xxx`命令生成公私钥，`-m PEM`用于指定格式为PEM。