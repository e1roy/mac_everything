#!/bin/bash

# 设置源文件和输出目录
SOURCE_ICNS="./iconprocessor/ic1.icns"
OUTPUT_ICONSET="./iconprocessor/ic1.iconset"
TARGET_DIR="./fastsearch/fastsearch/Assets.xcassets/AppIcon.appiconset"

# 创建输出目录（如果不存在）
mkdir -p "$OUTPUT_ICONSET"

# 使用iconutil将icns文件转换为iconset
echo "正在将 $SOURCE_ICNS 转换为iconset..."
iconutil --convert iconset --output "$OUTPUT_ICONSET" "$SOURCE_ICNS"

# 创建Contents.json文件
echo "正在创建Contents.json文件..."
cat > "$OUTPUT_ICONSET/Contents.json" << EOF
{
  "images" : [
    {
      "filename" : "icon_16x16.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_16x16@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_32x32.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_32x32@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_128x128.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_128x128@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_256x256.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_256x256@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_512x512.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "512x512"
    },
    {
      "filename" : "icon_512x512@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "512x512"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "转换完成！图标集位于 $OUTPUT_ICONSET"

# 复制到Assets.xcassets/AppIcon.appiconset目录
echo "正在复制图标集到 $TARGET_DIR..."

# 如果目标目录存在，先清空它
if [ -d "$TARGET_DIR" ]; then
    echo "目标目录已存在，正在清空..."
    rm -rf "$TARGET_DIR"/*
else
    echo "目标目录不存在，正在创建..."
    mkdir -p "$TARGET_DIR"
fi

# 复制所有文件
cp -a "$OUTPUT_ICONSET"/* "$TARGET_DIR"/

echo "复制完成！图标集已成功复制到 $TARGET_DIR"
