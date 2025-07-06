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

if [ -z "$AI_INSTALLER" ]; then
    echo "❌ 未找到 Ollama 安装路径，请确认是否已安装飞牛 AI 应用"
    exit 1
fi

cd "$AI_INSTALLER"

# 2. 打印当前版本
if [ -x "ollama/bin/ollama" ]; then
    echo "📦 当前 Ollama 版本："
    ./ollama/bin/ollama --version
else
    echo "⚠️ 找不到现有 Ollama 可执行文件，可能未完整安装"
fi

# 3. 备份旧版本
BACKUP_NAME="ollama_bk_$(date +%Y%m%d_%H%M%S)"
mv ollama "$BACKUP_NAME"
echo "📦 已备份原版 Ollama 为：$BACKUP_NAME"

# 4. 下载最新版本
FILENAME="ollama-linux-amd64.tgz"
echo "🌐 获取 Ollama 最新版本号..."

# 使用 GitHub API 获取最新版本号
#LATEST_TAG=$(curl -s https://api.github.com/repos/ollama/ollama/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
# 国内网络原因，或者代理，会遇到速率限制问题。 用一个小trick拉网页获取。
LATEST_TAG=$(curl -s https://github.com/ollama/ollama/releases | grep -oP '/ollama/ollama/releases/tag/\K[^"]+' | head -n 1)

if [ -z "$LATEST_TAG" ]; then
    echo "❌ 无法从 GitHub 获取 Ollama 最新版本号，请检查网络连接或代理设置"
    exit 1
fi

echo "⬇️ 正在下载版本 $LATEST_TAG ..."
curl -L -o "$FILENAME" "https://github.com/ollama/ollama/releases/download/$LATEST_TAG/ollama-linux-amd64.tgz"

# 5. 解压部署新版本
echo "📦 解压到 ollama/ ..."
mkdir -p ollama
tar -xzf "$FILENAME" -C ollama

# 6. 升级 pip 和 open-webui
PIP_DIR="$AI_INSTALLER/python/bin"
PYTHON_EXEC="/var/apps/ai_installer/target/python/bin/python3.12"

echo "⬆️ 正在升级 pip..."
"$PYTHON_EXEC" -m pip install --upgrade pip || {
    echo "❌ pip 升级失败，可能是网络问题或 GitHub 被墙"
    echo "   请尝试设置代理后重新运行："
    echo "   export https_proxy=http://127.0.0.1:7890"
    echo "   export http_proxy=http://127.0.0.1:7890"
    exit 1
}

echo "⬆️ 正在升级 open-webui..."
cd "$PIP_DIR"
./pip3 install --upgrade open_webui || {
    echo "❌ open-webui 升级失败"
    echo "🔎 常见原因：网络不通 / pip太旧 / 无法连接 PyPI"
    echo "✔️ 可尝试设置代理或手动升级："
    echo "   export https_proxy=http://127.0.0.1:7890"
    echo "   export http_proxy=http://127.0.0.1:7890"
    exit 1
}

# 7. 打印新版本确认
cd "$AI_INSTALLER"
echo "✅ 新 Ollama 版本为："
./ollama/bin/ollama --version

echo "🎉 升级完成！Ollama 与 open-webui 均为最新版本。"
