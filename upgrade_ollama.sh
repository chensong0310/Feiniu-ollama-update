#!/bin/bash

set -e
set -o pipefail

# 1. 查找 Ollama 安装路径
echo "🔍 查找 Ollama 安装路径..."
VOL_PREFIXES=(/vol1 /vol2 /vol3 /vol4 /vol5 /vol6 /vol7 /vol8 /vol9)
AI_INSTALLER=""

for vol in "${VOL_PREFIXES[@]}"; do
    if [ -d "$vol/@appcenter/ai_installer/ollama" ]; then
        AI_INSTALLER="$vol/@appcenter/ai_installer"
        echo "✅ 找到安装路径：$AI_INSTALLER"
        break
    fi
done

# 2. 如果未找到安装路径，尝试还原处中断的备份
if [ -z "$AI_INSTALLER" ]; then
    for vol in "${VOL_PREFIXES[@]}"; do
        testdir="$vol/@appcenter/ai_installer"
        if [ -d "$testdir" ]; then
            cd "$testdir"
            LAST_BK=$(ls -td ollama_bk_* 2>/dev/null | head -n 1)
            if [ -n "$LAST_BK" ] && [ ! -d "ollama" ]; then
                echo "⚠️ 检测到未完成的升级：$testdir 中存在备份 $LAST_BK，但当前没有 ollama/"
                mv "$LAST_BK" ollama
                echo "✅ 已恢复 $LAST_BK 为 ollama/"
                break
            fi
        fi
    done

    # 重新搜索 ollama 路径
    for vol in "${VOL_PREFIXES[@]}"; do
        if [ -d "$vol/@appcenter/ai_installer/ollama" ]; then
            AI_INSTALLER="$vol/@appcenter/ai_installer"
            echo "✅ 恢复后找到安装路径：$AI_INSTALLER"
            break
        fi
    done

    if [ -z "$AI_INSTALLER" ]; then
        echo "❌ 未找到 Ollama 安装路径，也没有检测到可恢复的备份"
        exit 1
    fi
fi

cd "$AI_INSTALLER"

# 3. 获取当前版本
echo "📦 正在检测当前 Ollama 客户端版本..."
CLIENT_VER=""
if [ -x "./ollama/bin/ollama" ]; then
    VERSION_RAW=$(./ollama/bin/ollama --version 2>&1)
    CLIENT_VER=$(echo "$VERSION_RAW" | grep -i "client version" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    if [ -n "$CLIENT_VER" ]; then
        echo "📦 当前已安装版本： v$CLIENT_VER（客户端）"
    else
        echo "⚠️ 无法获取版本号，原始输出："
        echo "$VERSION_RAW"
    fi
else
    echo "❌ 未找到 ollama 可执行文件"
fi

# 4. 获取最新版本
LATEST_TAG=$(curl -s https://github.com/ollama/ollama/releases | grep -oP '/ollama/ollama/releases/tag/\K[^"']+' | head -n 1)
if [ -z "$LATEST_TAG" ]; then
    echo "❌ 无法从 GitHub 获取最新 Ollama 版本号"
    exit 1
fi

echo "📦 最新版本号：$LATEST_TAG"
URL="https://github.com/ollama/ollama/releases/download/$LATEST_TAG/ollama-linux-amd64.tgz"
FILENAME="ollama-linux-amd64.tgz"

# 5. 如果版本一致，直接退出
if [ "$CLIENT_VER" = "${LATEST_TAG#v}" ]; then
    echo "✅ 当前已是最新版本，无需升级"
    exit 0
fi

# 6. 下载新版
if [ -f "$FILENAME" ]; then
    echo "🔍 检测到本地已有 $FILENAME，验证完整性..."
    if gzip -t "$FILENAME" 2>/dev/null; then
        echo "✅ 本地压缩包完整，跳过下载"
    else
        echo "❌ 本地文件损坏，重新下载"
        rm -f "$FILENAME"
    fi
fi

if [ ! -f "$FILENAME" ]; then
    echo "⬇️ 正在下载新版...
    if command -v aria2c >/dev/null 2>&1; then
        echo "🚀 使用 aria2c 多线程下载..."
        aria2c -x 16 -s 16 -k 1M -o "$FILENAME" "$URL"
    else
        echo "⬇️ 使用 curl 单线程下载..."
        curl -L -o "$FILENAME" "$URL"
    fi
fi

# 7. 备份旧版
BACKUP_NAME="ollama_bk_$(date +%Y%m%d_%H%M%S)"
mv ollama "$BACKUP_NAME"
echo "📦 已备份旧版为：$BACKUP_NAME"

# 8. 解压新版
mkdir -p ollama
tar -xzf "$FILENAME" -C ollama

# 9. 升级 pip + open-webui
PIP_DIR="$AI_INSTALLER/python/bin"
PYTHON_EXEC="/var/apps/ai_installer/target/python/bin/python3.12"

echo "⬆️ 升级 pip..."
"$PYTHON_EXEC" -m pip install --upgrade pip || {
    echo "❌ pip 升级失败"
    exit 1
}

echo "⬆️ 升级 open-webui..."
cd "$PIP_DIR"
./pip3 install --upgrade open_webui || {
    echo "❌ open-webui 升级失败"
    exit 1
}

# 10. 确认新版
cd "$AI_INSTALLER"
echo "📆 确认新 Ollama 版本..."
if [ -x "./ollama/bin/ollama" ]; then
    VERSION_RAW=$(./ollama/bin/ollama --version 2>&1)
    CLIENT_VER=$(echo "$VERSION_RAW" | grep -i "client version" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    if [ -n "$CLIENT_VER" ]; then
        echo "✅ 新 Ollama 版本为： v$CLIENT_VER（客户端）"
    else
        echo "⚠️ 无法提取版本号"
        echo "$VERSION_RAW"
    fi
else
    echo "❌ 未找到 ollama 执行文件"
fi

echo "🎉 升级完成！Ollama 与 open-webui 均已是最新版本"