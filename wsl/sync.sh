#!/bin/bash
# =====================================
# Script Name : sync.sh
# Description : 同步配置文件到指定目录
# Author      : Ky9oss
# Date        : 2025-08-28
# =====================================

# === 配置路径 ===
SRC_ZSHRC="<your_config>"
SRC_TMUX="<your_config>"
SRC_NVIM="<your_config>"
SRC_SCRIPT="<your_config>"
SRC_RSCRIPT="<your_config>"

DEST_DIR="<your_config>"
DEST_ZSHRC="<your_config>"
DEST_TMUX="<your_config>"
DEST_NVIM="<your_config>"
DEST_SCRIPT="<your_config>"
DEST_RSCRIPT="<your_config>"

# === 创建目标目录（如果不存在） ===
mkdir -p "$DEST_DIR"

# === 处理 .zshrc 文件：去掉包含 API_KEY 的行 ===
if [[ -f "$SRC_ZSHRC" ]]; then
    grep -v "API_KEY" "$SRC_ZSHRC" > "$DEST_ZSHRC"
    echo "[OK] .zshrc 已同步 (已移除 API_KEY)"
else
    echo "[WARN] 未找到 $SRC_ZSHRC"
fi

# === 复制 tmux 配置 ===
if [[ -f "$SRC_TMUX" ]]; then
    cp "$SRC_TMUX" "$DEST_TMUX"
    echo "[OK] tmux.conf.local 已同步"
else
    echo "[WARN] 未找到 $SRC_TMUX"
fi

# === 复制 nvim 配置目录 ===
if [[ -d "$SRC_NVIM" ]]; then
    # -r 递归复制，-u 仅覆盖较旧文件
    cp -ru "$SRC_NVIM" "$DEST_NVIM"
    echo "[OK] nvim 配置目录已同步"
else
    echo "[WARN] 未找到 $SRC_NVIM"
fi

# === 处理 sync.sh 文件：去掉包含 path 的行 ===
if [[ -f "$SRC_SCRIPT" ]]; then
    cat "$SRC_SCRIPT" | sed -E 's/^([A-Z_]+)=.*/\1="<your_config>"/' > "$DEST_SCRIPT"
    echo "[OK] sync.sh 已同步 (已移除PATH)"
else
    echo "[WARN] 未找到 $SRC_SCRIPT"
fi

if [[ -f "$SRC_RSCRIPT" ]]; then
    cat "$SRC_RSCRIPT" | sed -E 's/^([A-Z_]+)=.*/\1="<your_config>"/' > "$DEST_RSCRIPT"
    echo "[OK] rsync.sh 已同步 (已移除PATH)"
else
    echo "[WARN] 未找到 $SRC_RSCRIPT"
fi
