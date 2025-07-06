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


当前测试版本：    fnOS 0.9.13,  ollama 0.5.13 -> 0.9.5

```
taco@MS-FnOS:～$ curl -sL https://raw.githubusercontent.com/wzqvip/Feiniu-ollama-update/main/upgrade_ollama.sh | bash
🔍 查找 Ollama 安装路径...
✅ 找到安装路径：/vol1/@appcenter/ai_installer
📦 正在检测当前 Ollama 客户端版本...
📦 当前已安装版本：v0.5.13（客户端）
📦 已备份原版 Ollama 为：ollama_bk_20250707_023630
🌐 获取 Ollama 最新版本号...
⬇️ 正在下载版本 v0.9.5 ...
（省略）
📦 解压到 ollama/ ...
⬆️ 正在升级 pip...
（省略）
⬆️ 正在升级 open-webui...
（省略）
Successfully installed xxxx
✅ 新 Ollama 版本为：v0.9.5（客户端）
🎉 升级完成！Ollama 与 open-webui 均为最新版本。

```



---


致谢： https://post.smzdm.com/p/av7kp427/

---
