# FastSearch - macOS 文件搜索应用

<img width="1030" alt="image" src="https://github.com/user-attachments/assets/4ecb35a5-ebd5-467d-8b5e-e1caf506c2d8" />

![FastSearch Logo](https://img.shields.io/badge/FastSearch-macOS-blue?style=for-the-badge&logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-blue?style=for-the-badge)
![macOS](https://img.shields.io/badge/macOS-12.0+-000000?style=for-the-badge&logo=apple)

一个现代化、快速、易用的 macOS 文件搜索应用程序，使用 Swift 和 SwiftUI 构建。

## ✨ 功能特点

### 🔍 强大的搜索功能
- **实时搜索**: 输入即搜索，无需等待
- **智能匹配**: 支持模糊搜索和部分匹配
- **多路径搜索**: 同时搜索用户目录、桌面、文档、下载等
- **结果排序**: 智能排序，优先显示最相关的结果

### 🎨 现代化界面
- **原生设计**: 遵循 macOS Human Interface Guidelines
- **深色模式**: 完美支持浅色/深色主题切换
- **流畅动画**: 优雅的过渡动画和交互效果
- **响应式布局**: 适应不同窗口大小

### ⚡ 高性能
- **异步搜索**: 不阻塞主线程的后台搜索
- **内存优化**: 高效的内存使用和结果管理
- **快速响应**: 搜索结果毫秒级响应
- **限制机制**: 智能限制结果数量，保证性能

### 🛠 丰富的操作
- **快速打开**: 双击直接打开文件
- **Finder集成**: 一键在Finder中显示文件
- **复制操作**: 快速复制文件路径或文件名
- **右键菜单**: 完整的上下文菜单支持

## 🚀 快速开始

### 系统要求
- macOS 12.0 或更高版本
- Xcode 14.0 或更高版本

### 安装和运行

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd fastsearch
   ```

2. **使用构建脚本**
   ```bash
   ./build_and_run.sh
   ```

3. **或在 Xcode 中打开**
   ```bash
   open fastsearch/fastsearch.xcodeproj
   ```
   然后按 ⌘+R 运行项目

### 首次使用
1. 启动应用后，系统可能会要求文件访问权限
2. 点击"允许"以获得必要的文件系统访问权限
3. 在搜索框中输入文件名开始搜索

## 📖 使用指南

### 基本搜索
- 在搜索框中输入文件名或关键词
- 支持2个字符以上的实时搜索
- 搜索结果会实时更新

### 搜索技巧
- **完全匹配**: 输入完整文件名获得最精确结果
- **前缀匹配**: 输入文件名开头部分
- **包含搜索**: 输入文件名中的任意部分
- **忽略大小写**: 搜索时自动忽略大小写

### 文件操作
- **打开文件**: 双击文件或右键选择"打开"
- **显示位置**: 右键选择"在Finder中显示"
- **复制路径**: 右键选择"复制路径"
- **清空搜索**: 点击搜索框右侧的 ✕ 按钮

### 设置选项
- 点击菜单栏的"FastSearch" → "设置"
- 配置搜索范围、文件类型过滤等选项

## 🏗 技术架构

### 核心组件

```
FastSearchApp
├── ContentView          # 主界面视图
├── SearchManager        # 搜索逻辑管理
├── FileSearchResult     # 文件结果数据模型
├── FileRowView         # 文件行显示组件
└── SettingsView        # 设置界面
```

### 设计模式
- **MVVM**: Model-View-ViewModel 架构
- **观察者模式**: 使用 @ObservableObject 和 @Published
- **响应式编程**: Combine 框架处理异步操作

### 关键技术
- **SwiftUI**: 现代化的UI框架
- **FileManager**: 文件系统访问
- **NSWorkspace**: 系统集成
- **Combine**: 异步数据处理

## 📁 项目结构

```
fastsearch/
├── fastsearch/
│   ├── fastsearch/
│   │   ├── ContentView.swift      # 主界面
│   │   ├── SearchManager.swift    # 搜索管理器
│   │   ├── FileSearchResult.swift # 数据模型
│   │   ├── FileRowView.swift     # 文件行视图
│   │   ├── SettingsView.swift    # 设置界面
│   │   ├── FastSearchApp.swift   # 应用入口
│   │   ├── Assets.xcassets/      # 资源文件
│   │   └── fastsearch.entitlements # 权限配置
│   └── fastsearch.xcodeproj/     # Xcode项目文件
├── 需求文档.md                    # 详细需求文档
├── README.md                     # 项目说明
└── build_and_run.sh             # 构建脚本
```

## ⚙️ 配置说明

### 权限配置
应用使用沙盒模式，需要以下权限：
- `com.apple.security.files.user-selected.read-only`
- `com.apple.security.files.user-selected.read-write`
- `com.apple.security.files.downloads.read-only`
- `com.apple.security.files.downloads.read-write`

### 搜索范围
默认搜索以下目录：
- 用户主目录 (`~`)
- 桌面 (`~/Desktop`)
- 文档 (`~/Documents`)
- 下载 (`~/Downloads`)

## 🔧 自定义配置

### 修改搜索路径
在 `SearchManager.swift` 的 `getSearchPaths()` 方法中添加或修改搜索路径：

```swift
private func getSearchPaths() -> [URL] {
    var paths: [URL] = []
    
    // 添加自定义路径
    if let customPath = URL(string: "/your/custom/path") {
        paths.append(customPath)
    }
    
    return paths
}
```

### 调整性能参数
在 `SearchManager.swift` 中可以调整：
- `results.count >= 500`: 全局结果数量限制
- `results.count >= 100`: 单目录结果数量限制

## 🐛 问题排查

### 常见问题

1. **搜索结果为空**
   - 检查文件访问权限
   - 确认搜索的文件确实存在于搜索路径中

2. **搜索速度慢**
   - 考虑减少搜索路径范围
   - 启用设置中的"索引模式"

3. **无法打开文件**
   - 检查文件是否已移动或删除
   - 确认有相应应用程序打开该文件类型

### 调试模式
在 Xcode 中运行项目可以查看详细的控制台日志信息。

## 📄 许可证

本项目采用 MIT 许可证。详见 LICENSE 文件。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 开发环境设置
1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 📞 联系方式

如有问题或建议，请通过以下方式联系：
- 创建 GitHub Issue
- 发送邮件至开发者

---

**FastSearch** - 让文件搜索变得简单而快速！ 🚀
