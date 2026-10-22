# sa_widgets

Super Ability 通用组件包：**可复用的 UI 组件集合**。

本库**只负责"组件长什么样"这件事**：按钮、导航栏、加载指示器、空状态等常用 UI 组件。
不掺入业务逻辑、不掺入状态管理，依赖 `sa_theme` 获取设计令牌，
因此可以跨项目复用。

---

## ✨ 特性

- 🧩 **原子化组件**：每个组件职责单一，可组合使用。
- 🎨 **主题感知**：自动适配 `sa_theme` 的配色、排版、间距规范。
- 📱 **平台适配**：基于 Flutter Material Design 3，自动适配 iOS/Android 平台差异。
- ♿ **无障碍支持**：组件语义清晰，支持屏幕阅读器。
- 🧪 **易于测试**：纯 UI 组件，无状态管理依赖，单元测试友好。

---

## 📁 目录结构

```text
sa_widgets/
├── lib/
│   ├── sa_widgets.dart              # 包入口，统一 export
│   └── src/
│       ├── sa_app_bar.dart          # 通用导航栏组件
│       ├── sa_bottom_nav_bar.dart   # 底部导航栏组件
│       ├── sa_capsule_bottom_nav_bar.dart  # 胶囊高亮底部导航栏
│       ├── sa_button.dart           # 通用按钮组件
│       ├── sa_empty_state.dart      # 空状态组件
│       └── sa_loading.dart          # 加载指示器组件
├── test/                            # 单元与组件测试
└── pubspec.yaml
```

---

## 🚀 快速开始

### 1. 添加依赖

```yaml
# pubspec.yaml
dependencies:
  sa_widgets:
    path: packages/sa_widgets
```

### 2. 使用组件

```dart
import 'package:sa_widgets/sa_widgets.dart';

// 导航栏
const SAAppBar(
  title: '页面标题',
)

// 带返回按钮的导航栏
SAAppBar.withBack(
  context: context,
  title: '详情页',
)

// 底部导航栏
SABottomNavBar(
  tabs: const [
    SATabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: '首页'),
    SATabItem(icon: Icons.person_outline, activeIcon: Icons.person, label: '我的'),
  ],
  currentIndex: 0,
  onTap: (index) {},
)

// 胶囊高亮底部导航栏：选中项展开成"图标 + 文字"胶囊
SACapsuleBottomNavBar(
  tabs: const [
    SATabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: '主页'),
    SATabItem(icon: Icons.person_outline, activeIcon: Icons.person, label: '个人中心'),
  ],
  currentIndex: 0,
  onTap: (index) {},
)

// 按钮
SAButton(
  onPressed: () {},
  child: const Text('确认'),
)

// 文字按钮
SAButton.text(
  onPressed: () {},
  text: '查看更多',
)
```

---

## 🧩 组件一览

### SAAppBar - 通用导航栏

封装了常用导航栏配置，支持标题、返回按钮、操作按钮等。

```dart
// 标准导航栏
const SAAppBar(
  title: '页面标题',
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: _onSearch),
  ],
)

// 带返回按钮的导航栏
SAAppBar.withBack(
  context: context,
  title: '详情页',
  actions: [
    IconButton(icon: Icon(Icons.share), onPressed: _onShare),
  ],
)

// 自定义标题组件
SAAppBar(
  titleWidget: Row(
    children: [
      Icon(Icons.location_on),
      Text('上海'),
    ],
  ),
)
```

| 参数 | 类型 | 说明 |
|------|------|------|
| `title` | `String?` | 标题文字 |
| `titleWidget` | `Widget?` | 自定义标题组件（优先级高于 title） |
| `leading` | `Widget?` | 左侧按钮 |
| `actions` | `List<Widget>?` | 右侧操作按钮列表 |
| `centerTitle` | `bool` | 标题是否居中（默认 true） |
| `backgroundColor` | `Color?` | 背景色（默认使用主题色） |
| `elevation` | `double` | 阴影高度（默认 0） |
| `bottom` | `PreferredSizeWidget?` | 底部组件（如 TabBar） |

---

### SABottomNavBar - 底部导航栏

封装了底部 TabBar 的常用配置，支持自定义样式和切换回调。

```dart
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  static const _tabs = [
    SATabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: '主页'),
    SATabItem(icon: Icons.favorite_border, activeIcon: Icons.favorite, label: '喜欢'),
    SATabItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: '课程'),
    SATabItem(icon: Icons.person_outline, activeIcon: Icons.person, label: '个人中心'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomePage(),
          FavoritePage(),
          CoursesPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: SABottomNavBar(
        tabs: _tabs,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
```

| 参数 | 类型 | 说明 |
|------|------|------|
| `tabs` | `List<SATabItem>` | Tab 数据列表 |
| `currentIndex` | `int` | 当前选中索引 |
| `onTap` | `ValueChanged<int>` | 点击回调 |
| `backgroundColor` | `Color?` | 背景色 |
| `selectedColor` | `Color?` | 选中状态颜色 |
| `unselectedColor` | `Color?` | 未选中状态颜色 |
| `showLabels` | `bool` | 是否显示标签（默认 true） |
| `type` | `BottomNavigationBarType` | 导航栏类型（默认 fixed） |

#### SATabItem - Tab 数据模型

`SABottomNavBar` 与 `SACapsuleBottomNavBar` 共用这一数据模型。

```dart
const SATabItem({
  required IconData icon,           // 未选中状态的图标
  required String label,            // Tab 标签文字
  IconData? activeIcon,             // 选中状态的图标（可选，默认为 icon）
})
```

#### SABottomNavBarScaffold - 带底部导航栏的页面脚手架

自动处理底部安全区域和键盘弹出时的隐藏逻辑。

```dart
SABottomNavBarScaffold(
  appBar: const SAAppBar(title: '首页'),
  tabs: _tabs,
  currentIndex: _currentIndex,
  onTap: _onTabTapped,
  body: const HomePage(),
)
```

---

### SACapsuleBottomNavBar - 胶囊高亮底部导航栏

选中项展开成一颗「图标 + 文字」的胶囊，未选中项只保留图标，
用于强调"当前所在页面"。与 `SABottomNavBar` **共用 `SATabItem`**，可直接替换。

```dart
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  static const _tabs = [
    SATabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: '主页'),
    SATabItem(icon: Icons.favorite_border, activeIcon: Icons.favorite, label: '喜欢'),
    SATabItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: '课程'),
    SATabItem(icon: Icons.person_outline, activeIcon: Icons.person, label: '个人中心'),
    SATabItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: '设置'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: SACapsuleBottomNavBar(
        tabs: _tabs,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
```

| 参数 | 类型 | 说明 |
|------|------|------|
| `tabs` | `List<SATabItem>` | Tab 数据列表 |
| `currentIndex` | `int` | 当前选中索引，越界时视为无选中项 |
| `onTap` | `ValueChanged<int>` | 点击回调 |
| `backgroundColor` | `Color?` | 导航栏背景色，默认主题 `surface` |
| `pillColor` | `Color?` | 胶囊底色，默认主题 `textPrimary`（深色模式自动反相） |
| `pillContentColor` | `Color?` | 胶囊内图标与文字颜色，默认主题 `textInverse` |
| `iconColor` | `Color?` | 未选中图标颜色，默认主题 `iconDefault` |
| `duration` | `Duration` | 切换动画时长，默认 260ms |
| `curve` | `Curve` | 切换动画曲线，默认 `Curves.easeOutCubic` |

`SACapsuleBottomNavBar.height`（64）为导航栏内容高度，不含底部安全区。

#### 切换动效

一次切换同时发生 4 层动画，全部受 `duration` / `curve` 控制：

| 变化 | 实现 |
|------|------|
| 胶囊底色渐显 / 内边距撑开 | `AnimatedContainer` |
| 线性图标 → 实心图标交叉淡入放大 | `AnimatedSwitcher` |
| 标签展开 / 收起 | `AnimatedCrossFade`（淡入 + 尺寸渐变） |
| 相邻 Tab 平滑让位，形成"胶囊滑动"观感 | `spaceEvenly` + Tab 按内容宽度排布 |

#### 使用建议

- **Tab 数量 4~5 个、标签建议不超过 4 个汉字**：选中项预留 2 倍宽度，
  320pt 窄屏下更长的标签会自动省略号截断而不是溢出。
- 未选中项触控区不小于 48×44，满足无障碍最小点击尺寸。
- 每个 Tab 都会向读屏软件暴露 `button` + `selected` 语义与标签文字。
- 需要"图标 + 文字常驻"的传统底栏用 `SABottomNavBar`；需要突出当前项时用本组件。

---

### SAButton - 通用按钮

封装了常用按钮样式，支持加载状态、禁用状态。

```dart
// 主按钮
SAButton(
  onPressed: _onSubmit,
  child: const Text('提交'),
)

// 加载状态
SAButton(
  onPressed: _onSubmit,
  isLoading: true,
  child: const Text('提交'),
)

// 禁用状态
SAButton(
  onPressed: null,  // 或 isDisabled: true
  child: const Text('不可点击'),
)

// 文字按钮
SAButton.text(
  onPressed: _onTap,
  text: '查看更多',
  textColor: Colors.blue,
)
```

| 参数 | 类型 | 说明 |
|------|------|------|
| `onPressed` | `VoidCallback?` | 点击回调 |
| `child` | `Widget` | 按钮内容 |
| `isLoading` | `bool` | 是否处于加载状态（默认 false） |
| `isDisabled` | `bool` | 是否禁用（默认 false） |

---

### SAEmptyState - 空状态

页面无数据时显示的占位组件。

```dart
const SAEmptyState(
  icon: Icons.inbox_outlined,
  title: '暂无数据',
  subtitle: '点击刷新按钮重新加载',
)

// 带操作按钮
SAEmptyState(
  icon: Icons.error_outline,
  title: '加载失败',
  subtitle: '网络连接异常',
  action: SAButton.text(
    onPressed: _onRetry,
    text: '重试',
  ),
)
```

---

### SALoading - 加载指示器

统一的加载动画组件。

```dart
// 全屏加载
const SALoading()

// 内联加载
const SALoading.inline()

// 带遮罩的加载
const SALoading.overlay()
```

---

## 🎨 主题集成

组件自动从 `sa_theme` 获取设计令牌：

- **颜色**：使用 `ThemeData.colorScheme` 的语义颜色
- **排版**：使用 `SATextStyles` 的排版规范
- **间距**：使用 `SASpacing` 的间距规范
- **圆角**：使用 `SARadius` 的圆角规范

确保在 `MaterialApp` 中注入 `sa_theme` 主题：

```dart
import 'package:sa_theme/sa_theme.dart';

MaterialApp(
  theme: SAAppTheme.light(),
  darkTheme: SAAppTheme.dark(),
  themeMode: ThemeMode.system,
  home: const MainPage(),
);
```

---

## 🧪 测试

```bash
cd packages/sa_widgets
flutter pub get
flutter test
```

---

## 🧭 设计说明

### 组件设计原则

1. **单一职责**：每个组件只做一件事，如 `SAAppBar` 只负责顶部导航，不处理页面内容。
2. **可组合性**：组件之间可以灵活组合，如 `SABottomNavBarScaffold` 组合了 `Scaffold` 和 `SABottomNavBar`。
3. **主题感知**：组件自动适配当前主题，无需手动传入颜色、字体等样式参数。
4. **平台无关**：基于 Flutter Material Design 3，不依赖特定平台 API。

### 与 sa_theme 的关系

```
sa_theme: 设计令牌（颜色、排版、间距）
    ↓
sa_widgets: UI 组件（使用令牌渲染样式）
    ↓
业务代码: 页面组装（使用组件构建界面）
```

---

## 📄 版本与迁移

- 当前为本地 `path` 依赖，稳定后迁移到远程 Git 仓库，业务代码无需改动。
- 新增组件时同步更新本 README 的组件一览表格。

---

## 📚 相关包

| 包名 | 职责 |
|------|------|
| `sa_theme` | 设计令牌（颜色、排版、间距） |
| `sa_widgets` | UI 组件（本包） |
| `sa_core` | 核心服务（日志、缓存、配置） |
| `sa_network` | 网络请求（Dio 封装） |
| `sa_utils` | 工具函数（日期、字符串、验证等） |
