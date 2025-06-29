#!/bin/bash

# FastSearch macOS 应用构建脚本

echo "🔍 FastSearch - macOS 文件搜索应用"
echo "=================================="

# 进入项目目录
cd "$(dirname "$0")/fastsearch"

# 检查 Xcode 是否安装
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode 未安装或命令行工具未设置"
    echo "请安装 Xcode 并运行: sudo xcode-select --install"
    exit 1
fi

echo "📦 清理项目..."
xcodebuild clean -project fastsearch.xcodeproj -scheme fastsearch

echo "🔨 构建项目..."
xcodebuild build -project fastsearch.xcodeproj -scheme fastsearch -configuration Debug

if [ $? -eq 0 ]; then
    echo "✅ 构建成功！"
    echo "🚀 启动应用..."
    
    # 查找构建后的应用
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "fastsearch.app" -type d 2>/dev/null | head -1)
    
    if [ -n "$APP_PATH" ]; then
        open "$APP_PATH"
        echo "✨ FastSearch 已启动！"
    else
        echo "⚠️  无法找到构建的应用，请在 Xcode 中手动运行"
    fi
else
    echo "❌ 构建失败，请检查错误信息"
    exit 1
fi
