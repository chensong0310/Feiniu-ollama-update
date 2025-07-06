# Feiniu-ollama-update

一键更新飞牛上面Ollama的脚本




## 🚀 一键升级命令

首先从应用商店停用ollama

然后ssh链接上飞牛，执行以下命令

```bash
curl -sL https://raw.githubusercontent.com/wzqvip/Feiniu-ollama-update/main/upgrade_ollama.sh | bash
```

成功之后从应用商店手动启用。


飞牛上面的ollama很不错，但是版本低了好多模型没法pull。 飞牛目前忙于其他事情暂时没有更新，提供一个更新脚本来放便操作。


当前测试版本：    fnOS 0.9.13,  ollama 

```
taco@MS-FnOS:～$ curl -sL https://raw.githubusercontent.com/wzqvip/Feiniu-ollama-update/main/upgrade_ollama.sh | bash
🔍 查找 Ollama 安装路径...
✅ 找到安装路径：/vol1/@appcenter/ai_installer
📦 当前 Ollama 版本：
Warning: could not connect to a running Ollama instance
Warning: client version is 0.5.13
📦 已备份原版 Ollama 为：ollama_bk_20250707_023630
🌐 获取 Ollama 最新版本号...
⬇️ 正在下载版本 v0.9.5 ...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  2 1250M    2 35.8M    0     0   548k      0  0:38:56  0:01:06  0:37:50 1307k
100 1250M  100 1250M    0     0  2995k      0  0:07:07  0:07:07 --:--:-- 10.3M
📦 解压到 ollama/ ...
⬆️ 正在升级 pip...
Requirement already satisfied: pip in /var/apps/ai_installer/target/python/lib/python3.12/site-packages (24.3.1)
Collecting pip
  Downloading pip-25.1.1-py3-none-any.whl.metadata (3.6 kB)
Downloading pip-25.1.1-py3-none-any.whl (1.8 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.8/1.8 MB 134.2 kB/s eta 0:00:00
Installing collected packages: pip
  Attempting uninstall: pip
    Found existing installation: pip 24.3.1
    Uninstalling pip-24.3.1:
      Successfully uninstalled pip-24.3.1
Successfully installed pip-25.1.1
⬆️ 正在升级 open-webui...
Requirement already satisfied: open_webui in /var/apps/ai_installer/target/python/lib/python3.12/site-packages (0.5.20)
Collecting open_webui
  Downloading open_webui-0.6.15-py3-none-any.whl.metadata (23 kB)
Collecting accelerate (from open_webui)
  Downloading accelerate-1.8.1-py3-none-any.whl.metadata (19 kB)
Requirement already satisfied: aiocache in /var/apps/ai_installer/target/python/lib/python3.12/site-packages (from open_webui) (0.12.3)
。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。
（省略）
。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。
Successfully installed accelerate-1.8.1 azure-ai-documentintelligence-1.0.2 brotli-1.1.0 chromadb-0.6.3 duckduckgo-search-8.0.2 einops-0.8.1 elasticsearch-9.0.1 fake-useragent-2.1.0 google-ai-generativelanguage-0.6.15 google-genai-1.15.0 google-generativeai-0.8.5 langchain-0.3.24 langchain-community-0.3.23 langchain-core-0.3.68 langchain-text-splitters-0.3.8 langsmith-0.3.45 loguru-0.7.3 onnxruntime-1.20.1 open_webui-0.6.15 peewee-3.18.1 pgvector-0.4.0 pillow-11.2.1 pinecone-6.0.2 pinecone-plugin-interface-0.0.7 primp-0.15.0 pypandoc-1.15 python-multipart-0.0.20 python-pptx-1.0.2 python-socketio-5.13.0 rapidocr-onnxruntime-1.4.4 requests-2.32.4 sentence-transformers-4.1.0 starlette-compress-1.6.0 tencentcloud-sdk-python-3.0.1336 uvicorn-0.34.2 validators-0.35.0 youtube-transcript-api-1.1.0 zstandard-0.23.0
✅ 新 Ollama 版本为：
Warning: could not connect to a running Ollama instance
Warning: client version is 0.9.5
🎉 升级完成！Ollama 与 open-webui 均为最新版本。

```



---


致谢： https://post.smzdm.com/p/av7kp427/

---
