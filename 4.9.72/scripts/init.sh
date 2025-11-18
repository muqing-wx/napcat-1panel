#!/bin/bash

# --- 1. 动态路径搜索 ---
SEARCH_ROOTS=("/opt" "/var" "/usr" "/home" "/root")
ASTROBOT_DATA_SRC_DIR=""
for root in "${SEARCH_ROOTS[@]}"; do
    if [ ! -d "$root" ]; then continue; fi
    SEARCH_RESULT=$(find "$root" -type d -path '*/astrbot/data' 2>/dev/null | head -n 1)
    if [ -n "$SEARCH_RESULT" ]; then
        ASTROBOT_DATA_SRC_DIR="$SEARCH_RESULT"
        break
    fi
done

# --- 2. 准备路径变量 ---
HOST_APP_ROOT_DIR="."
ASTROBOT_DATA_PLACEHOLDER_DIR="${HOST_APP_ROOT_DIR}/astrbot_data_placeholder"
FINAL_ASTROBOT_PATH=""

if [ -n "${ASTROBOT_DATA_SRC_DIR}" ]; then
    FINAL_ASTROBOT_PATH="${ASTROBOT_DATA_SRC_DIR}"
else
    mkdir -p "${ASTROBOT_DATA_PLACEHOLDER_DIR}"
    FINAL_ASTROBOT_PATH="${ASTROBOT_DATA_PLACEHOLDER_DIR}"
fi

# --- 3. 【核心修复】将动态路径写入 .env 文件 ---
# 先删除 .env 文件中可能存在的旧行，防止重复
if [ -f ./.env ]; then
    sed -i '/^ASTROBOT_DATA_PATH=/d' ./.env
fi
# 将新的、正确的路径追加到 .env 文件末尾
echo "ASTROBOT_DATA_PATH=${FINAL_ASTROBOT_PATH}" >> ./.env

# --- 4. 创建应用所需目录 ---
mkdir -p "${HOST_APP_ROOT_DIR}/data"
mkdir -p "${HOST_APP_ROOT_DIR}/config"
mkdir -p "${HOST_APP_ROOT_DIR}/logs"

# --- 5. 生成 webui.json 配置文件 ---
# 确保 .env 文件存在并加载，以便获取 WEBUI_TOKEN 等变量
if [ -f ./.env ]; then
    source ./.env
fi

WEBUI_JSON_PATH="${HOST_APP_ROOT_DIR}/config/webui.json"
rm -f "${WEBUI_JSON_PATH}"

# 使用已加载的环境变量生成配置文件
cat <<EOF > "${WEBUI_JSON_PATH}"
{
    "host": "${WEBUI_HOST}",
    "prefix": "${WEBUI_PREFIX}",
    "port": 6099,
    "token": "${WEBUI_TOKEN}",
    "loginRate": ${WEBUI_LOGIN_RATE}
}
EOF
