#!/bin/bash

# Color definitions for output
# 输出颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print a separator line
# 打印分隔线函数
print_separator() {
    echo "--------------------------------------------------------"
}

# Core function to check unlock status for a given movie ID and region name
# 核心检测函数，接收影片ID和名称作为参数
check_unlock() {
    local movie_name="$1"
    local movie_id="$2"
    local expected_url="https://www.netflix.com/title/${movie_id}"

    # Use curl to get the final effective URL after all redirects
    # 使用 curl 获取所有重定向后的最终有效URL
    # -4 强制使用 IPv4
    local final_url=$(curl --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36" \
                            -sL -o /dev/null -w "%{url_effective}" -4 "${expected_url}")

    # Check if the final URL contains the original movie title URL
    # 判断最终URL是否仍然包含原始影片的URL
    if [[ "$final_url" == *"/title/${movie_id}"* ]]; then
        printf "%-25s : ${GREEN}解锁 (Unlocked)${NC}\n" "$movie_name"
    else
        printf "%-25s : ${RED}未解锁 (Locked)${NC}\n" "$movie_name"
    fi
}

# --- Script Starts Here ---
# --- 脚本主程序开始 ---

echo ""
echo "Netflix 解锁情况检测脚本 (IPv4)"
echo "Netflix Unlock Status Checker (IPv4)"
print_separator

# 检测 Netflix 自制剧 (全球通用)
echo -e "${YELLOW}检测 Netflix 自制剧 (Netflix Originals)...${NC}"
check_unlock "Netflix 自制剧" "80049832" # Our Planet / 我们的星球
print_separator

# 检测非自制剧 (绝命毒师)
echo -e "${YELLOW}检测 Netflix 非自制剧 (Licensed Content)...${NC}"
check_unlock "非自制剧 (绝命毒师)" "70143836"  # Breaking Bad / 绝命毒师
print_separator

echo "检测完成！"
echo ""
