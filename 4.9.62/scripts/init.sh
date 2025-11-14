#!/bin/bash

# 定义 Napcat 应用在宿主机上的根目录
HOST_APP_ROOT_DIR="/opt/1panel/apps/napcat"

# 确保 Napcat 自身需要的目录存在
mkdir -p "${HOST_APP_ROOT_DIR}/data"
mkdir -p "${HOST_APP_ROOT_DIR}/config"
mkdir -p "${HOST_APP_ROOT_DIR}/logs"

# 读取 .env 文件中的环境变量
source ./.env

# 定义配置文件的绝对路径
WEBUI_JSON_PATH="${HOST_APP_ROOT_DIR}/config/webui.json"

# 如果配置文件已存在，先删除，确保每次都使用最新的设置
rm -f "${WEBUI_JSON_PATH}"

# 创建并写入新的配置文件 (cat > 会自动创建文件)
cat <<EOF > "${WEBUI_JSON_PATH}"
{
    "host": "${WEBUI_HOST}",
    "prefix": "${WEBUI_PREFIX}",
    "port": ${PANEL_APP_PORT_HTTP},
    "token": "${WEBUI_TOKEN}",
    "loginRate": ${WEBUI_LOGIN_RATE}
}
EOF
