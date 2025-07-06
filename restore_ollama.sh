#!/bin/bash

set -e
set -o pipefail

# 自动查找路径
VOL_PREFIXES=(/vol1 /vol2 /vol3 /vol4 /vol5 /vol6 /vol7 /vol8 /vol9)
AI_INSTALLER=""
for vol in "${VOL_PREFIXES[@]}"; do
    if [ -d "$vol/@appcenter/ai_installer" ]; then
        AI_INSTALLER="$vol/@appcenter/ai_installer"
        break
    fi
done

if [ -z "$AI_INSTALLER" ]; then
    echo "❌ 没找到 ai_installer 安装目录"
    exit 1
fi

cd "$AI_INSTALLER"

# 查找最新的 ollama_bk_xxx 文件夹
BACKUP_DIR=$(ls -td ollama_bk_* 2>/dev/null | head -n 1)

if [ -z "$BACKUP_DIR" ]; then
    echo "❌ 未找到任何 Ollama 备份文件夹"
    exit 1
fi

echo "📦 找到备份文件夹：$BACKUP_DIR"

# 如果当前已有 ollama/，先改名备份
if [ -d "ollama" ]; then
    FAILED_NAME="ollama_failed_$(date +%Y%m%d_%H%M%S)"
    mv ollama "$FAILED_NAME"
    echo "⚠️ 当前 ollama 目录已重命名为 $FAILED_NAME"
fi

# 还原备份
mv "$BACKUP_DIR" ollama
echo "✅ 已还原 $BACKUP_DIR 为 ollama/"

# 验证版本
if [ -x "ollama/bin/ollama" ]; then
    echo "🎯 当前版本为："
    ./ollama/bin/ollama --version
else
    echo "⚠️ 找不到 ollama 可执行文件，可能备份不完整"
fi
