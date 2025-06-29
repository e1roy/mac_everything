#!/bin/bash

# FastSearch 打包脚本
# 作者：GitHub Copilot
# 创建日期：2025年6月29日

# 设置颜色变量
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}===== FastSearch 打包脚本 =====${NC}"

# 获取项目目录
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
XCODE_PROJECT="$PROJECT_DIR/fastsearch/fastsearch.xcodeproj"
APP_NAME="fastsearch"
BUILD_DIR="$PROJECT_DIR/build"
RELEASE_DIR="$PROJECT_DIR/release"

# 检查 Xcode 是否已安装
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}错误: 未找到 xcodebuild 命令。请确保已安装 Xcode。${NC}"
    exit 1
fi

# 创建构建和发布目录
mkdir -p "$BUILD_DIR"
mkdir -p "$RELEASE_DIR"

# 确保工作目录干净
echo -e "${YELLOW}清理先前的构建...${NC}"

# 运行清理脚本
if [ -f "$PROJECT_DIR/clean.sh" ]; then
    echo -e "${YELLOW}执行清理脚本...${NC}"
    "$PROJECT_DIR/clean.sh"
fi

# 清理构建目录
if [ -d "$BUILD_DIR" ]; then
    echo -e "${YELLOW}清理构建目录...${NC}"
    rm -rf "$BUILD_DIR"/*
    mkdir -p "$BUILD_DIR"
fi

# 清理发布目录中的应用和DMG
if [ -d "$RELEASE_DIR/$APP_NAME.app" ]; then
    rm -rf "$RELEASE_DIR/$APP_NAME.app"
fi
if [ -f "$RELEASE_DIR/$APP_NAME.dmg" ]; then
    rm "$RELEASE_DIR/$APP_NAME.dmg"
fi
if [ -f "$RELEASE_DIR/FastSearch.dmg" ]; then
    rm "$RELEASE_DIR/FastSearch.dmg"
fi

# 为构建目录添加build系统删除权限
echo -e "${YELLOW}为构建目录添加权限...${NC}"
xattr -w com.apple.xcode.CreatedByBuildSystem true "$BUILD_DIR"

# 构建应用程序
echo -e "${YELLOW}正在构建应用程序...${NC}"
xcbuild_log=$(mktemp)
xcodebuild -project "$XCODE_PROJECT" -scheme "$APP_NAME" -configuration Release CONFIGURATION_BUILD_DIR="$BUILD_DIR" clean build > "$xcbuild_log" 2>&1

# 检查构建是否成功
if [ $? -ne 0 ]; then
    echo -e "${RED}构建失败，查看日志:${NC}"
    cat "$xcbuild_log"
    rm "$xcbuild_log"
    exit 1
else
    echo -e "${GREEN}构建成功!${NC}"
    rm "$xcbuild_log"
fi

# 拷贝应用到发布目录
echo -e "${YELLOW}正在复制应用到发布目录...${NC}"
cp -R "$BUILD_DIR/$APP_NAME.app" "$RELEASE_DIR/"

# 签名应用程序（如果有开发者证书）
DEVELOPER_ID=""
DEVELOPER_IDS=$(security find-identity -v -p codesigning | grep "Developer ID Application" | awk -F '"' '{print $2}')

if [ -n "$DEVELOPER_IDS" ]; then
    echo -e "${YELLOW}找到以下开发者证书:${NC}"
    echo "$DEVELOPER_IDS"
    
    # 使用第一个证书
    DEVELOPER_ID=$(echo "$DEVELOPER_IDS" | head -1)
    
    echo -e "${YELLOW}正在使用证书签名应用: $DEVELOPER_ID${NC}"
    codesign --force --deep --sign "$DEVELOPER_ID" "$RELEASE_DIR/$APP_NAME.app"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}签名失败${NC}"
        echo -e "${YELLOW}继续创建未签名版本...${NC}"
    else
        echo -e "${GREEN}签名成功!${NC}"
    fi
else
    echo -e "${YELLOW}未找到开发者证书，将创建未签名版本${NC}"
fi

# 创建 DMG 文件
echo -e "${YELLOW}正在创建 DMG 映像文件...${NC}"

# 创建临时目录和设置DMG内容
TMP_DMG_DIR="$BUILD_DIR/dmg_contents"
mkdir -p "$TMP_DMG_DIR"
cp -R "$RELEASE_DIR/$APP_NAME.app" "$TMP_DMG_DIR/"
ln -s /Applications "$TMP_DMG_DIR/Applications"

# 创建漂亮的背景（可选）
mkdir -p "$TMP_DMG_DIR/.background"
if [ -f "$PROJECT_DIR/dmg_background.png" ]; then
    cp "$PROJECT_DIR/dmg_background.png" "$TMP_DMG_DIR/.background/"
    BACKGROUND_OPTION="-background $PROJECT_DIR/dmg_background.png"
else
    BACKGROUND_OPTION=""
fi

# 创建DMG
echo -e "${YELLOW}生成带有应用程序图标的DMG安装程序...${NC}"
hdiutil create -volname "FastSearch" -srcfolder "$TMP_DMG_DIR" -ov -format UDZO "$RELEASE_DIR/FastSearch.dmg" $BACKGROUND_OPTION

# 清理临时目录
rm -rf "$TMP_DMG_DIR"

# 完成
echo -e "${GREEN}===== 打包完成! =====${NC}"
echo -e "${BLUE}应用程序位置:${NC} $RELEASE_DIR/$APP_NAME.app"
echo -e "${BLUE}DMG 安装包位置:${NC} $RELEASE_DIR/FastSearch.dmg"
echo -e "${YELLOW}双击 DMG 文件打开，然后将应用拖到应用程序文件夹即可安装${NC}"
