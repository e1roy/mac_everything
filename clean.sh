#!/bin/bash

# 清理 Xcode 编译产物的脚本
# 作者：GitHub Copilot
# 创建日期：2025年6月29日

# 设置颜色变量
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}===== FastSearch 清理脚本 =====${NC}"
echo "清理开始..."

# 获取项目目录
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo -e "${YELLOW}项目目录: ${PROJECT_DIR}${NC}"

# 清理 Xcode 派生数据
echo -e "${YELLOW}清理 Xcode 派生数据...${NC}"
DERIVED_DATA_DIR="${HOME}/Library/Developer/Xcode/DerivedData"
DERIVED_DIRS=$(find "$DERIVED_DATA_DIR" -name "*fastsearch*" -type d)

if [ -n "$DERIVED_DIRS" ]; then
    echo "$DERIVED_DIRS" | while read -r dir; do
        echo -e "${YELLOW}删除: $dir${NC}"
        rm -rf "$dir"
    done
    echo -e "${GREEN}派生数据已清理完成${NC}"
else
    echo -e "${YELLOW}没有找到 fastsearch 相关的派生数据${NC}"
fi

# 清理 build 目录
echo -e "${YELLOW}清理项目中的 build 目录...${NC}"
find "$PROJECT_DIR" -name "build" -type d -exec rm -rf {} \; 2>/dev/null || true
echo -e "${GREEN}build 目录已清理完成${NC}"

# 清理其他临时文件
echo -e "${YELLOW}清理其他临时文件...${NC}"
find "$PROJECT_DIR" -name "*.xcuserstate" -delete
find "$PROJECT_DIR" -name "*.DS_Store" -delete
echo -e "${GREEN}临时文件已清理完成${NC}"

# 如果项目中有 Pods 目录，也可以清理
if [ -d "$PROJECT_DIR/fastsearch/Pods" ]; then
    echo -e "${YELLOW}清理 Pods 目录...${NC}"
    rm -rf "$PROJECT_DIR/fastsearch/Pods"
    echo -e "${GREEN}Pods 已清理完成${NC}"
fi

echo -e "${GREEN}===== 清理完成! =====${NC}"
echo -e "${BLUE}现在您可以重新构建项目了${NC}"
