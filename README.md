# Super Ability

<div align="center">

一款设计与交互优秀的跨平台应用，基于 Flutter 构建。

[![Flutter](https://img.shields.io/badge/Flutter-3.47%2B-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13%2B-0175C2?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-blue)]()
[![License](https://img.shields.io/badge/License-MIT-green)]()

</div>

---

## 📋 目录

- [项目简介](#-项目简介)
- [技术栈](#-技术栈)
- [环境要求](#-环境要求)
- [快速开始](#-快速开始)
- [项目结构](#-项目结构)
- [私有库](#-私有库)
- [编码规范](#-编码规范)
- [Git 规范](#-git-规范)
- [开发流程](#-开发流程)

---

## 📖 项目简介

Super Ability 是一款以优秀设计与交互体验为核心的跨平台移动应用，前期聚焦 iOS 与 Android 平台。项目采用 Flutter 框架，遵循 Clean Architecture 思想与 Feature-First 目录组织方式，追求代码的高可维护性与可扩展性。

## 🛠 技术栈

| 类别 | 技术 | 版本 | 说明 |
|------|------|------|------|
| 框架 | Flutter | ≥ 3.47.0 | 跨平台 UI 框架 |
| 语言 | Dart | ≥ 3.13.0 | 编程语言 |
| 路由 | go_router | ^18.1.1 | 声明式路由方案 |
| 状态管理 | GetX | ^5.0.0 | 轻量级状态管理与依赖注入 |
| 网络请求 | Dio | ^5.11.1 | HTTP 客户端 |
| 屏幕适配 | flutter_screenutil | ^6.0.0 | 多尺寸屏幕适配 |
| 代码规范 | very_good_analysis | ^11.0.0 | 静态分析规则集 |

## 📦 环境要求

- **Flutter**: ≥ 3.47.0
- **Dart SDK**: ≥ 3.13.0
- **Android Studio**: Rabbit 1 (2026.2.1) 或更高版本
- **Xcode**: 最新稳定版（iOS 开发必需）
- **CocoaPods**: ≥ 1.13.0（iOS 依赖管理）

验证环境：

```bash
flutter doctor
```

## 🚀 快速开始

### 1. 克隆项目

```bash
git clone <repository_url>
cd super_ability
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 运行项目

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# 指定设备
flutter devices
flutter run -d <device_id>
```

### 4. 构建发布版本

```bash
# iOS Release
flutter build ipa

# Android Release
flutter build apk --release
flutter build appbundle --release
```

---

## 📁 项目结构

采用 **Feature-First**（功能优先）的目录组织方式，每个功能模块自包含其 UI、逻辑、数据层代码，便于团队协作与模块维护。

```
super_ability/
├── packages/                       # 本地私有库（后期迁移至远程仓库）
│   ├── sa_core/                    # 核心基础包 - 常量、枚举、基础配置
│   ├── sa_theme/                   # 主题包 - 颜色、字体、间距、主题配置
│   ├── sa_widgets/                 # 通用组件包 - 可复用的 UI 组件
│   ├── sa_network/                 # 网络框架包 - Dio 封装、拦截器链、响应模型（无业务码）
│   └── sa_utils/                   # 工具类包 - 校验、日期、字符串扩展
│
├── lib/                            # 主应用代码
│   ├── main.dart                   # 应用入口
│   ├── app.dart                    # App 根 Widget、主题配置
│   │
│   ├── core/                       # 全局核心模块
│   │   ├── constants/              # 常量定义
│   │   ├── router/                 # 路由配置
│   │   └── ...
│   │
│   ├── features/                   # 功能模块（按业务划分）
│   │   ├── auth/
│   │   ├── home/
│   │   └── profile/
│   │
│   └── shared/                     # 跨功能共享模块
│
├── android/                        # Android 平台代码
├── ios/                            # iOS 平台代码
├── test/                           # 测试代码
└── pubspec.yaml                    # 项目依赖配置
```

### 目录职责说明

| 目录 | 职责 |
|------|------|
| `packages/` | 本地私有库，封装主题、组件、网络、工具等可复用模块，后期迁移至远程仓库 |
| `lib/core/` | 与业务无关的基础设施，包括常量、路由等 |
| `lib/features/` | 按业务功能划分，每个功能内部遵循 Clean Architecture 三层结构 |
| `lib/features/*/data/` | 数据层：API 调用、本地缓存、数据模型（DTO）、仓库实现 |
| `lib/features/*/domain/` | 领域层：业务实体、仓库接口、用例，不依赖外部框架 |
| `lib/features/*/presentation/` | 展示层：页面、Controller、模块级组件 |
| `lib/shared/` | 多个 feature 之间共享的模型、组件和扩展方法 |

---

## 📦 私有库

项目采用本地私有库的方式组织可复用模块，所有私有库位于 `packages/` 目录下。当前通过 `path` 依赖引入，便于本地编码调试；后期稳定后将迁移至远程 Git 仓库拉取。

### 私有库一览

| 包名 | 说明 | 核心内容 |
|------|------|----------|
| `sa_core` | 核心基础包 | 全局常量 `SAConstants`、通用枚举 `LoadStatus` / `RequestStatus` |
| `sa_theme` | 主题包 | 语义颜色令牌 `SAColorRole` / `SAPalette`、运行时主题 `SAThemeTokens`（`context.colors`）、服务端换肤 `SAColorConfig`、字体排版 `SATextStyles`、间距规范 `SASpacing` / `SARadius`、主题构建 `SAAppTheme` |
| `sa_widgets` | 通用组件包 | 按钮 `SAButton`、加载指示 `SALoading`、空状态 `SAEmptyState`、导航栏 `SAAppBar`、底部导航 `SABottomNavBar` / 胶囊高亮 `SACapsuleBottomNavBar` |
| `sa_network` | 网络框架包 | Dio 封装 `DioClient`、响应模型 `ApiResponse`、可插拔拦截器（Auth/Retry/Log/空参过滤）。**不内置业务码**，业务解析由 `ApiResponseParser` 注入 |
| `sa_utils` | 工具类包 | 输入校验 `Validators`、日期工具 `DateUtils`、字符串扩展 `StringExtensions` |

### 包依赖关系

```
sa_core          ← 无外部依赖（基础包）
  ↑
  ├── sa_theme   ← 依赖 sa_core
  ├── sa_utils   ← 依赖 sa_core
  └── sa_widgets ← 依赖 sa_core + sa_theme

sa_network       ← 仅依赖 dio（独立网络库，无业务耦合，可跨项目复用）
```

### 私有库内部结构（以 sa_xxx 为例）

```
packages/sa_xxx/
├── lib/
│   ├── sa_xxx.dart           # 包入口，统一 export
│   └── src/                  # 实现文件
│       ├── xxx.dart
│       └── yyy.dart
├── pubspec.yaml
└── analysis_options.yaml     # 统一使用 very_good_analysis
```

### 迁移至远程仓库

当私有库稳定后，将每个包推送到独立 Git 仓库，主项目 `pubspec.yaml` 中的依赖方式从 `path` 切换为 `git`：

```yaml
# 当前（本地 path）
sa_core:
  path: packages/sa_core

# 后期（远程 git）
sa_core:
  git:
    url: https://github.com/your-org/sa_core.git
    ref: v0.1.0
```

---

## 📐 编码规范

### 命名规范

| 类型 | 风格 | 示例 |
|------|------|------|
| 文件名 | `snake_case` | `user_profile_page.dart` |
| 类名 / 枚举名 | `PascalCase` | `UserProfilePage`, `AppStatus` |
| 变量名 / 函数名 | `camelCase` | `userName`, `fetchUserData()` |
| 常量 | `camelCase` 或 `SCREAMING_SNAKE_CASE` | `defaultTimeout`, `API_BASE_URL` |
| 私有成员 | 前缀 `_` | `_counter`, `_buildBody()` |
| 资源文件 | `snake_case` | `ic_home.png`, `app_logo.png` |

### 文件组织规范

- **每个文件只定义一个公共类**，文件名与主类名对应
- **单文件行数建议不超过 300 行**，超出应拆分为更小的组件或文件
- **import 顺序**：Dart SDK → Flutter SDK → 第三方包 → 项目文件，各组之间空一行

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:io';

// 2. Flutter SDK
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. 第三方包
import 'package:dio/dio.dart';
import 'package:get/get.dart';

// 4. 项目文件
import 'package:super_ability/core/constants/api_constants.dart';
import 'package:super_ability/features/auth/domain/entities/user.dart';
```

### 注释规范

```dart
/// 用户信息页面。
///
/// 展示当前登录用户的个人资料，支持编辑头像与昵称。
/// 使用 [UserController] 管理状态。
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  // 构建用户信息卡片
  Widget _buildInfoCard(User user) {
    // ...
  }
}
```

- 公共 API 使用 `///` 文档注释
- 复杂逻辑使用 `//` 行内注释说明 **为什么** 这样做，而非描述代码本身
- 避免无意义注释（如 `// 返回按钮` 配一个返回图标）

### Widget 构建规范

```dart
// ✅ 推荐：提取子组件，保持 build 方法简洁
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: const _HomeContent(),
      floatingActionButton: const _CreateButton(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(title: const Text('首页'));
  }
}

// ❌ 避免：build 方法中嵌套过深
```

- 使用 `const` 构造函数，所有参数为 `final` 时使用 `const`
- Widget 组合超过 3 层时应提取为独立组件
- 优先使用 `const` Widget 以减少重建开销

### 状态管理规范（GetX）

```dart
class AuthController extends GetxController {
  // 响应式变量
  final user = Rxn<User>();
  final isLoading = false.obs;

  // 业务逻辑
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      user.value = await _loginUseCase.execute(email, password);
    } catch (e) {
      // 错误处理
    } finally {
      isLoading.value = false;
    }
  }
}
```

- Controller 只处理业务逻辑，不包含 UI 代码
- 使用 `Rx` 类型管理响应式状态
- 在 `onInit()` 中初始化数据，在 `onClose()` 中释放资源

### 错误处理

`sa_network` 只处理网络层异常，**不内置任何业务码**。业务方通过实现 `ApiResponseParser` 将原始响应解析为业务数据：

```dart
// 业务侧自定义解析器（示例：约定 code==0 为成功）
class MyParser<T> extends ApiResponseParser<T> {
  const MyParser(this.fromJson);

  final T Function(Map<String, dynamic>) fromJson;

  @override
  T parse(dynamic raw) {
    final map = raw as Map<String, dynamic>;
    final code = map['code'] as int;
    if (code != 0) {
      throw ApiException(map['message'] as String? ?? '请求失败', code: code);
    }
    return fromJson(map['data'] as Map<String, dynamic>);
  }
}

// 调用
final response = await client.get<User>(
  '/user/1',
  parser: MyParser(User.fromJson),
);

switch (response) {
  case ApiSuccess<User>():
    render(response.data);
  case ApiError():
    showError(response.message);
}
```

- 网络层异常由 `DioClient` 统一转换为 `ApiException`（超时、断网、401/5xx）
- 业务码异常由业务解析器抛出 `ApiException`，`DioClient` 封装为 `ApiError`
- 页面层根据状态展示对应 UI（加载、成功、错误、空状态）
- 详见 [`packages/sa_network/README.md`](packages/sa_network/README.md)

---

## 📝 Git 规范

### 分支策略

| 分支 | 用途 |
|------|------|
| `main` | 生产分支，始终保持可发布状态 |
| `develop` | 开发集成分支 |
| `feature/<name>` | 功能开发，如 `feature/user-auth` |
| `fix/<name>` | 缺陷修复，如 `fix/login-crash` |
| `hotfix/<name>` | 紧急修复 |
| `release/<version>` | 发布准备 |

### Commit 规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
<type>(<scope>): <subject>

[body]

[footer]
```

| type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat(auth): 添加指纹登录` |
| `fix` | 修复缺陷 | `fix(home): 修复列表滚动卡顿` |
| `docs` | 文档变更 | `docs(readme): 更新项目说明` |
| `style` | 代码格式（不影响逻辑） | `style: 统一缩进与空行` |
| `refactor` | 重构 | `refactor(network): 重构拦截器链` |
| `perf` | 性能优化 | `perf(list): 优化长列表渲染性能` |
| `test` | 测试相关 | `test(auth): 补充登录单元测试` |
| `chore` | 构建/工具变更 | `chore: 升级 Flutter 版本` |

---

## 🔄 开发流程

### 新增一个功能模块的步骤

1. 在 `lib/features/` 下创建功能目录，包含 `data/`、`domain/`、`presentation/` 三层
2. 在 `domain/` 中定义实体与仓库接口
3. 在 `data/` 中实现数据模型、数据源与仓库
4. 在 `presentation/` 中编写 Controller 与页面
5. 在 `core/router/` 中注册路由
6. 编写对应的单元测试与 Widget 测试

### 代码审查清单

- [ ] 遵循项目编码规范与命名规范
- [ ] 无 `print` 语句残留（使用日志框架）
- [ ] Widget 使用 `const` 优化
- [ ] 错误处理完善，无静默失败
- [ ] 响应式布局适配多种屏幕尺寸
- [ ] 通过 `flutter analyze` 无警告
- [ ] 关键逻辑有单元测试覆盖

### 常用命令

```bash
# 代码分析
flutter analyze

# 格式化代码
dart format lib/ test/

# 运行测试
flutter test
flutter test --coverage

# 清理构建缓存
flutter clean && flutter pub get
```

---

## 📄 许可证

本项目仅供学习与内部使用。

---

<div align="center">

**Happy Coding! 🎉**

</div>
