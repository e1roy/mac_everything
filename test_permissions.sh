#!/bin/bash

# FastSearch 权限测试脚本
# 作者：GitHub Copilot
# 创建日期：2025年6月29日

# 设置颜色变量
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}===== FastSearch 权限测试脚本 =====${NC}"

# 获取项目目录
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_PATH="$PROJECT_DIR/release/fastsearch.app"

if [ ! -d "$APP_PATH" ]; then
    echo -e "${RED}错误: 应用程序不存在，请先运行 ./build_release.sh${NC}"
    exit 1
fi

echo -e "${YELLOW}应用程序路径: $APP_PATH${NC}"

# 检查 entitlements 文件
ENTITLEMENTS_PATH="$PROJECT_DIR/fastsearch/fastsearch/fastsearch.entitlements"
echo -e "${YELLOW}检查 entitlements 配置...${NC}"

if [ -f "$ENTITLEMENTS_PATH" ]; then
    echo -e "${GREEN}✅ entitlements 文件存在${NC}"
    
    # 检查关键权限配置
    if grep -q "com.apple.security.files.user-selected.read-only" "$ENTITLEMENTS_PATH"; then
        echo -e "${GREEN}✅ 用户选择文件权限已配置${NC}"
    else
        echo -e "${RED}❌ 缺少用户选择文件权限${NC}"
    fi
    
    if grep -q "com.apple.security.files.bookmarks.app-scope" "$ENTITLEMENTS_PATH"; then
        echo -e "${GREEN}✅ 书签权限已配置${NC}"
    else
        echo -e "${RED}❌ 缺少书签权限${NC}"
    fi
    
    if grep -q "com.apple.security.temporary-exception.files.home-relative-path.read-only" "$ENTITLEMENTS_PATH"; then
        echo -e "${GREEN}✅ 用户主目录相对路径权限已配置${NC}"
    else
        echo -e "${RED}❌ 缺少用户主目录相对路径权限${NC}"
    fi
    
else
    echo -e "${RED}❌ entitlements 文件不存在${NC}"
fi

# 检查应用的权限配置
echo -e "${YELLOW}检查应用程序权限签名...${NC}"
codesign -d --entitlements :- "$APP_PATH" 2>/dev/null | head -20

echo -e "${YELLOW}启动应用程序进行测试...${NC}"
echo -e "${BLUE}请在应用中测试以下功能:${NC}"
echo -e "1. 应用启动时是否显示权限请求对话框"
echo -e "2. 点击'选择文件夹'是否能正确打开文件选择器"
echo -e "3. 选择用户主目录后是否能搜索到文件"
echo -e "4. 权限状态是否正确显示"

# 启动应用
open "$APP_PATH"

echo -e "${GREEN}===== 测试完成 =====${NC}"
echo -e "${YELLOW}如果应用无法访问用户目录，请尝试:${NC}"
echo -e "1. 在应用中点击'选择文件夹'按钮"
echo -e "2. 选择您的用户主目录或要搜索的文件夹"
echo -e "3. 或者在系统偏好设置中授予'完全磁盘访问'权限"
