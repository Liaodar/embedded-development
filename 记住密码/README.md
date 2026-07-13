# 奶龙 — 密码管理 App

一个简单、离线、安全的密码管理工具，帮你在手机上记住所有账号密码。

> **Android only** · 完全离线 · 数据存本地 · AES-256 加密

---

## ✨ 功能

| 功能 | 说明 |
|------|------|
| 🔐 **加密存储** | AES-256-CBC 加密，密码不以明文存入数据库 |
| 👁️ **App 内查看** | 加密存储但 App 内随时可看明文 |
| 🏠 **主页保密** | 主页面只显示网站名称，不暴露账号密码 |
| 🔍 **搜索** | 按网站名称快速搜索 |
| 📝 **详情页** | 点击进入查看完整账号密码（只读） |
| ✏️ **编辑/删除** | 主页卡片上直接操作 |

---

## 📱 安装

下载 [安装包/奶龙.apk](安装包/奶龙.apk) 传到手机，点击安装即可。

> 首次安装需要在手机设置中允许「安装未知应用」。

---

## 🔧 从源码构建

```bash
# 1. 克隆项目
cd 源码

# 2. 安装依赖
flutter pub get

# 3. 构建 APK
flutter build apk --release
```

> 构建产物在 `build/app/outputs/flutter-apk/app-release.apk`

---

## ⚠️ 安全提醒

**构建前请修改加密密钥！**

打开 `lib/services/crypto_service.dart`，找到这行：

```dart
static const String _passphrase = 'your-secret-passphrase-change-me-please';
```

改为只有你自己知道的密钥，建议 16 位以上，包含大小写字母 + 数字 + 特殊符号。**改完后重新构建 APK 即可生效。**

> 如果使用默认密钥上传到 GitHub，任何人都能用该密钥解密你的数据。

---

## 🛠 技术栈

| 技术 | 用途 |
|------|------|
| Flutter 3.44 | 跨平台 UI 框架 |
| sqflite | 本地 SQLite 数据库 |
| encrypt | AES-256-CBC 加密 |
| crypto | SHA-256 密钥派生 |

---

## 📂 项目结构

```
源码/
├── lib/
│   ├── main.dart                  # 应用入口
│   ├── models/
│   │   └── account.dart           # 数据模型
│   ├── pages/
│   │   ├── home_page.dart         # 主页（只显示网站名）
│   │   ├── detail_page.dart       # 详情页（只读查看）
│   │   └── add_edit_page.dart     # 添加/编辑页
│   ├── services/
│   │   └── crypto_service.dart    # AES 加密服务
│   └── database/
│       └── database_helper.dart   # 数据库操作
├── pubspec.yaml                   # 依赖配置
└── android/                       # Android 构建配置
```

---

## 🔒 隐私说明

- 所有数据存储在手机本地，不上传任何服务器
- 不需要注册账号，不需要网络权限
- 密码使用 AES-256-CBC 加密后存入数据库
- App 内查看时自动解密，明文仅存在于内存中
