#!/bin/bash
# =====================================
# Script Name : rsync.sh
# Description : 同步github项目
# Author      : Ky9oss
# Date        : 2025-09-04
# =====================================


# === 配置路径 ===
SRC_BLOG="<your_config>"
SRC_PLUGGED="<your_config>"

GH_DIR="<your_config>"
DEST_DIR="<your_config>"

GH_BLOG="<your_config>"
DEST_PLUGGED="<your_config>"

rsync -av --delete --progress \
      --include='temp/keep.txt' \
      --exclude='package-lock.json' \
      --exclude='npm-debug.log' \
      --exclude='.env' \
      --exclude='.env.production' \
      --exclude='node_modules/' \
      --exclude='dist/' \
      --exclude='.output/' \
      --exclude='.git/' \
      --exclude='src/data/' \
      --exclude='src/assets/images/' \
      --exclude='src/assets/images/default.png' \
      $SRC_BLOG $GH_BLOG

rsync -av --delete --progress \
      --exclude='*.log' \
      --exclude='*.swp' \
      --exclude='*.tmp' \
      --exclude='*.bak' \
      --exclude='**/.git/' \
      --exclude='**/.github/' \
      --exclude='.env' \
      --exclude='.env.production' \
      --exclude='LuaSnip/' \
      $SRC_PLUGGED $DEST_PLUGGED
