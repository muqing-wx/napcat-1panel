# NapCat-1Panel
在1Panel面板运行NapCat
<div align="center">
  <img src="https://raw.githubusercontent.com/muqing-wx/napcat-1panel/main/img/logo.jpeg"/>
</div>

---

## 使用方式

*注意:* 如果国内服务器访问 GitHub 速度慢，可以尝试使用 `ghproxy.com` 等代理服务。

docker镜像已添加自建代理
如果无法拉取镜像请修改docker-compose中的docker.sakuno.top/mlikiowa/napcat-docker:latest
修改为mlikiowa/napcat-docker:latest或者添加你的代理

### 1. 使用 git 命令获取应用（推荐）

在 `1Panel` 的 `计划任务` 中创建一个类型为 `Shell 脚本` 的任务，将以下命令粘贴进去，手动执行一次即可。

#### 国外服务器或网络好的环境
```bash
#!/bin/sh

install_dir=$(which 1pctl | xargs grep '^BASE_DIR=' | cut -d'=' -f2)

rm -rf $install_dir/1panel/resource/apps/local/napcat-1panel-napcat

git clone -b napcat https://github.com/muqing-wx/napcat-1panel.git "$install_dir/1panel/resource/apps/local/napcat-1panel-napcat"

if [ $? -eq 0 ]; then
    rm -rf $install_dir/1panel/resource/apps/local/napcat
    mv $install_dir/1panel/resource/apps/local/napcat-1panel-napcat $install_dir/1panel/resource/apps/local/napcat
    echo "Success: 应用已从您的仓库 muqing-wx/napcat-1panel 更新！"
else
    echo "Error: 从您的仓库克隆失败，请检查网络或仓库地址。"
    exit 1
fi
```
#### 国内服务器（使用代理）
```bash
#!/bin/sh

install_dir=$(which 1pctl | xargs grep '^BASE_DIR=' | cut -d'=' -f2)

rm -rf $install_dir/1panel/resource/apps/local/napcat-1panel-napcat

git clone -b napcat https://ghproxy.com/https://github.com/muqing-wx/napcat-1panel.git "$install_dir/1panel/resource/apps/local/napcat-1panel-napcat"

if [ $? -eq 0 ]; then
    rm -rf $install_dir/1panel/resource/apps/local/napcat
    mv $install_dir/1panel/resource/apps/local/napcat-1panel-napcat $install_dir/1panel/resource/apps/local/napcat
    echo "Success: 应用已从您的仓库 muqing-wx/napcat-1panel 更新！"
else
    echo "Error: 从您的仓库克隆失败，请检查网络或仓库地址。"
    exit 1
fi
```
执行成功后，去 `1Panel` 的 `应用商店` -> `本地` 页面，点击右上角的 `刷新应用列表` 即可看到。

### 2. 使用压缩包方式获取应用

如果您服务器上没有安装 `git`，可以使用这个方法。

#### 国外服务器或网络好的环境
```bash
#!/bin/sh

install_dir=$(which 1pctl | xargs grep '^BASE_DIR=' | cut -d'=' -f2)
APP_TARGET_DIR="$install_dir/1panel/resource/apps/local"
TEMP_ZIP_FILE="$APP_TARGET_DIR/napcat-temp.zip"
TEMP_EXTRACT_DIR="$APP_TARGET_DIR/napcat-1panel-napcat"

# 下载压缩包
curl -L -o "$TEMP_ZIP_FILE" https://github.com/muqing-wx/napcat-1panel/archive/refs/heads/napcat.zip
if [ $? -ne 0 ]; then echo "Error: 下载失败"; exit 1; fi

# 解压并清理
unzip -o "$TEMP_ZIP_FILE" -d "$APP_TARGET_DIR/"
rm -f "$TEMP_ZIP_FILE"
rm -rf "$APP_TARGET_DIR/napcat"
mv "$TEMP_EXTRACT_DIR" "$APP_TARGET_DIR/napcat"
echo "Success: 应用已通过压缩包方式安装！"
```

执行后刷新本地应用列表即可。

---
## 配置图
<div align="center">
  <img src="https://raw.githubusercontent.com/muqing-wx/napcat-1panel/main/img/config.jpeg"/>
</div>
