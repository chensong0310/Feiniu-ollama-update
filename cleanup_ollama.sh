#!/bin/bash

set -e
set -o pipefail

FORCE_CLEAN=0
[ "$1" = "--force" ] && FORCE_CLEAN=1

echo "🧹 正在查找 Ollama 安装目录..."
VOL_PREFIXES=(/vol1 /vol2 /vol3 /vol4 /vol5 /vol6 /vol7 /vol8 /vol9)
AI_INSTALLER=""

for vol in "${VOL_PREFIXES[@]}"; do
    if [ -d "$vol/@appcenter/ai_installer" ]; then
        AI_INSTALLER="$vol/@appcenter/ai_installer"
        echo "✅ 找到目录：$AI_INSTALLER"
        break
    fi
done

if [ -z "$AI_INSTALLER" ]; then
    echo "❌ 未找到 Ollama 安装路径"
    exit 1
fi

cd "$AI_INSTALLER"

# 找出目标文件夹/文件
BK_DIRS=$(ls -d ollama_bk_* 2>/dev/null || true)
TGZ_FILES=$(ls ollama*.tgz 2>/dev/null || true)

# 清理函数
clean_items() {
    for item in "$@"; do
        if [ -e "$item" ]; then
            echo "🗑️ 删除：$item"
            rm -rf "$item"
        fi
    done
}

# 删除备份目录
if [ -n "$BK_DIRS" ]; then
    echo "📦 将删除以下备份目录："
    echo "$BK_DIRS"
    if [ $FORCE_CLEAN -eq 1 ]; then
        clean_items $BK_DIRS
    else
        echo "❓ 是否删除这些目录？[y/N]"
        read -r confirm
        [[ "$confirm" =~ ^[Yy]$ ]] && clean_items $BK_DIRS || echo "⏩ 已跳过备份目录删除"
    fi
else
    echo "ℹ️ 未发现备份目录"
fi

# 删除下载的 .tgz 文件
if [ -n "$TGZ_FILES" ]; then
    echo "📦 将删除以下压缩包文件："
    echo "$TGZ_FILES"
    if [ $FORCE_CLEAN -eq 1 ]; then
        clean_items $TGZ_FILES
    else
        echo "❓ 是否删除这些压缩包？[y/N]"
        read -r confirm
        [[ "$confirm" =~ ^[Yy]$ ]] && clean_items $TGZ_FILES || echo "⏩ 已跳过压缩包删除"
    fi
else
    echo "ℹ️ 未发现下载的压缩包"
fi

echo "✅ 清理完成！"
