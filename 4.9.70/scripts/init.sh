#!/bin/bash

# 定义要搜索的根目录列表
SEARCH_ROOTS=("/opt" "/var" "/usr" "/home" "/root")
ASTROBOT_DATA_SRC_DIR=""

# 遍历列表，查找 'astrbot/data' 目录，找到第一个后立即停止
for root in "${SEARCH_ROOTS[@]}"; do
    if [ ! -d "$root" ]; then
        continue
    fi
    
    SEARCH_RESULT=$(find "$root" -type d -path '*/astrbot/data' 2>/dev/null | head -n 1)

    if [ -n "$SEARCH_RESULT" ]; then
        ASTROBOT_DATA_SRC_DIR="$SEARCH_RESULT"
        break
    fi
done

# 定义本地应用根目录和备用占位符目录
HOST_APP_ROOT_DIR="."
ASTROBOT_DATA_PLACEHOLDER_DIR="${HOST_APP_ROOT_DIR}/astrbot_data"

# 如果成功找到目录，则使用其真实路径；否则，创建并使用本地占位符目录
if [ -n "${ASTROBOT_DATA_SRC_DIR}" ]; then
    export ASTROBOT_DATA_PATH="${ASTROBOT_DATA_SRC_DIR}"
else
    mkdir -p "${ASTROBOT_DATA_PLACEHOLDER_DIR}"
    export ASTROBOT_DATA_PATH="${ASTROBOT_DATA_PLACEHOLDER_DIR}"
fi

# 创建 Napcat 运行所需的基础目录
mkdir -p "${HOST_APP_ROOT_DIR}/data"
mkdir -p "${HOST_APP_ROOT_DIR}/config"
mkdir -p "${HOST_APP_ROOT_DIR}/logs"

# 加载 .env 文件中的环境变量
source ./.env

# 动态生成 webui.json 配置文件
WEBUI_JSON_PATH="${HOST_APP_ROOT_DIR}/config/webui.json"
rm -f "${WEBUI_JSON_PATH}"

cat <<EOF > "${WEBUI_JSON_PATH}"
{
    "host": "${WEBUI_HOST}",
    "prefix": "${WEBUI_PREFIX}",
    "port": 6099,
    "token": "${WEBUI_TOKEN}",
    "loginRate": ${WEBUI_LOGIN_RATE}
}
EOF
