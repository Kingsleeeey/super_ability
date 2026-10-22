# sa_theme

Super Ability 主题私有库：**语义化设计令牌 + 随主题下发的运行时颜色 + 服务端动态换肤**。

本库**只负责"长什么样"这件事**：颜色、排版、间距、`ThemeData` 组装。
不掺入业务组件（在 `sa_widgets`）、不掺入状态管理，也不依赖屏幕适配库，
因此可以跨项目复用。

---

## ✨ 特性

- 🎨 **三层颜色结构**：原始色值 `SAColors` → 语义角色 `SAColorRole` → 运行时令牌 `SAThemeTokens`。
- 🌗 **明暗模式零成本**：业务只写角色，不写色值，`context.colors` 自动给出当前亮度下的颜色。
- 🛰 **服务端换肤**：`SAColorConfig` 只覆盖接口下发到的角色，其余回落默认色板，接口字段增减不需要改客户端。
- 📦 **`ThemeExtension` 下发**：令牌挂在 `ThemeData` 上，不依赖全局单例，测试里可任意构造主题。
- 🔤 **排版真正接入 `ThemeData.textTheme`**：`SATextStyles` 覆盖全部 15 个槽位，不会出现两套字号并存。
- 📐 **间距与圆角规范**：4 的倍数基准 `SASpacing`、`SARadius`。
- 🧪 **测试覆盖**：色板完整性、JSON 往返、颜色解析容错、主题注入与回退均有断言。

---

## 📁 目录结构

```text
sa_theme/
├── lib/
│   ├── sa_theme.dart              # 包入口，统一 export
│   └── src/
│       ├── app_colors.dart        # SAColors：原始色值表（设计稿取色）
│       ├── app_palette.dart       # SAColorRole + SAPalette + SAColorConfig + SAColorUtils
│       ├── app_spacing.dart       # SASpacing + SARadius
│       ├── app_text_styles.dart   # SATextStyles：排版令牌
│       ├── app_typography.dart    # SATypography：令牌 → TextTheme
│       ├── app_theme_tokens.dart  # SAThemeTokens(ThemeExtension) + BuildContext 扩展
│       └── app_theme.dart         # SAAppTheme：组装 ThemeData
├── test/                          # 单元与组件测试
└── pubspec.yaml
```

---

## 🚀 快速开始

### 1. 添加依赖

```yaml
# pubspec.yaml
dependencies:
  sa_theme:
    path: packages/sa_theme
```

### 2. 接入 MaterialApp

```dart
import 'package:sa_theme/sa_theme.dart';

MaterialApp(
  theme: SAAppTheme.light(),
  darkTheme: SAAppTheme.dark(),
  themeMode: ThemeMode.system,
  home: const HomePage(),
);
```

### 3. 在业务里取色

```dart
class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; // 当前亮度下的语义色板

    return Card(
      child: Text(
        '标题',
        style: TextStyle(color: colors.textPrimary),
      ),
    );
  }
}
```

`Theme.of(context)` 也能用：`SAAppTheme` 已把令牌写进 `colorScheme` 与组件主题，
Material 组件（按钮、卡片、输入框）无需额外处理就会跟着色板走。

---

## 🎨 颜色：三层结构

| 层 | 类型 | 什么时候用 |
|----|------|-----------|
| 原始色值 | `SAColors` | 只在色板定义里出现，业务代码不直接引用；它就是设计稿的取色表 |
| 语义角色 | `SAColorRole` + `SAPalette` | 需要脱离 `BuildContext` 的场合（如构造 `ThemeData`、生成分享图） |
| 运行时令牌 | `SAThemeTokens` / `context.colors` | 绝大多数 UI 代码 |

```dart
// 角色 → 颜色
context.colors.textPrimary;                    // 一级文字
context.colors[SAColorRole.primarySoft];       // 泛化访问
SAPalette.dark.border;                         // 显式取暗色色板
```

### 语义角色一览

| 角色 | 用途 | 亮色 | 暗色 |
|------|------|------|------|
| `primary` | 主按钮、强调元素 | 品牌主色 | 品牌主色提亮 |
| `onPrimary` | 主色之上的文字/图标 | 白 | 深色 |
| `primarySoft` | 选中态背景、次级容器 | 主色浅底 | 主色深底 |
| `background` | 页面底色 | 浅灰 | 近黑 |
| `surface` | 卡片、弹层底色 | 纯白偏暖 | 深灰 |
| `surfaceMuted` | 输入框、分组区块底色 | 次级灰 | 次级深灰 |
| `overlay` | 遮罩（半透明） | 40% 黑 | 60% 黑 |
| `textPrimary` | 一级文字 | 深 | 浅 |
| `textSecondary` | 二级文字 | 中灰 | 中浅灰 |
| `textTertiary` | 占位、禁用 | 浅灰 | 深灰 |
| `textInverse` | 深色容器上的反色文字 | 近白 | 近黑 |
| `border` / `divider` | 描边 / 分割线 | outline / divider | outline / divider |
| `iconDefault` / `iconActive` | 图标默认 / 选中 | 次要灰 / 主色 | 三级灰 / 主色 |
| `success` `warning` `error` `info` | 反馈色 | Material 语义色 | 提亮版本 |
| `link` | 可点击文字 | 主色加深 | 主色提亮 |
| `gradientStart` `gradientEnd` | 主渐变两端 | 品牌渐变 | 深色渐变 |

`SAPalette.primaryGradient` 直接给出 `LinearGradient`，无需业务拼两端色。

---

## 🌗 明暗模式

`SAAppTheme.light()` / `dark()` 分别绑定 `SAPalette.light` / `SAPalette.dark`。
新增一个角色时，只要在两套色板里各补一行，所有组件主题与 `context.colors`
同时生效——序列化、合并、插值都是按角色遍历的通用逻辑，不存在"漏了一个字段"。

```dart
final palette = context.colors; // 暗色模式下自动是 SAPalette.dark 那一套
final isDark = context.isDarkMode;
```

---

## 🛰 服务端动态换肤

接口返回一份 JSON，客户端解析后交给 `SAAppTheme`，只覆盖下发到的角色：

```json
{
  "light": { "primary": "#FF6F3C", "gradientEnd": "#FFB03A" },
  "dark":  { "primary": "#FFB03A" }
}
```

```dart
final config = SAColorConfig.fromJson(response.data as Map<String, dynamic>);

MaterialApp(
  theme: SAAppTheme.light(config: config),
  darkTheme: SAAppTheme.dark(config: config),
);
```

解析规则：

- 支持分模式结构（如上）与扁平结构 `{"primary": "#FF6F3C"}`；扁平值同时作用于两种模式，**模式专属配置优先级更高**。
- 颜色可写成 `#RGB` / `#RGBA` / `#RRGGBB` / `#AARRGGBB`、去掉 `#` 的同形字符串、`0x` 前缀、整数色值或 `Color` 实例。
- **未知键名与无法解析的值会被忽略**，服务端加字段或改字段不会让客户端崩溃或丢默认色。
- `toJson()` 输出可直接写进本地缓存，`SAColorConfig.fromJson(cfg.toJson()) == cfg`。
- 需要整包替换配色（而不是打补丁）时，用 `SAAppTheme.fromPalette(palette:, brightness:)`。

```dart
// 单个颜色解析（需要严格校验时用 parse）
SAColorUtils.tryParse('#6750A4');   // 失败返回 null
SAColorUtils.parse('oops');         // 抛 FormatException
SAColorUtils.toHex(const Color(0x806750A4)); // '#806750A4'
```

---

## 🔤 排版

`SATextStyles` 是常量排版令牌（字号、字重、行高、字距），`SATypography` 把它们
组装成带颜色的 `TextTheme` 并挂进 `ThemeData`：

```dart
Theme.of(context).textTheme.bodyMedium;   // 与 SATextStyles.bodyMedium 同源
context.textTheme.titleLarge;
const Text('固定样式', style: SATextStyles.labelSmall);
```

排版令牌**不带颜色**，颜色由 `SATypography.build(palette:)` 按当前色板注入，
因此明暗模式与换肤都不需要维护第二套文字样式。

需要屏幕适配时交给系统 `textScaler` 或应用侧的 `MediaQuery`，本库不引入
`flutter_screenutil`——主题令牌必须在任意时刻（包括动画插值中）可构造，
不能依赖全局初始化状态。

---

## 📐 间距与圆角

```dart
SizedBox(height: SASpacing.lg);          // 16
EdgeInsets.all(SASpacing.sm);            // 8
BorderRadius.circular(SARadius.lg);      // 12
```

| `SASpacing` | xxs 2 · xs 4 · sm 8 · md 12 · lg 16 · xl 20 · xxl 24 · xxxl 32 · xxxxl 48 |
| `SARadius`  | sm 4 · md 8 · lg 12 · xl 16 · full 999 |

---

## 🧱 组件主题覆盖范围

`SAAppTheme` 用同一份逻辑构建明暗两套主题，以下组件主题全部取自色板：

| 组件 | 取色来源 |
|------|----------|
| `ColorScheme` | `primary` `onPrimary` `primarySoft` `surface` `textPrimary` `error` `border` `divider` `overlay` |
| AppBar | `surface` + `scrolledUnderElevation: 0`（无滚动色调叠加） |
| Card / Dialog | `surface` + `border` 描边，`SARadius.lg` / `xl` |
| Elevated / Outlined / Text 按钮 | `primary` `primarySoft` `link`；Elevated 默认撑满宽度、高度 48 |
| InputDecoration | `surfaceMuted` 填充，`border`/`primary`/`error` 三态描边 |
| Divider / ListTile / Chip / Icon | `divider` `textPrimary` `iconDefault` `primarySoft` |
| FAB / SnackBar | `primary` `onPrimary`，SnackBar 用 `textPrimary` 反相底 + `textInverse` 文字 |

---

## 🧪 测试

```bash
cd packages/sa_theme
flutter pub get
flutter test
```

覆盖点：色板角色完整性与可读性对比、`toJson/fromJson` 往返不丢角色、
非法颜色输入容错、动态配色只覆盖给定角色、未安装令牌时按亮度回退。

---

## 🧭 设计说明

相对早期版本（`custom_theme` 私有库）的取舍：

**沿用**
- `ThemeExtension` + `BuildContext` 扩展：让设计令牌随主题下发，明暗切换与换肤只改一处。
- 服务端配色配置对象：颜色可以接口下发、本地缓存、部分覆盖。
- `copyWith` / `lerp`：支持主题过渡动画。

**改进**
- **语义角色取代编号令牌**。`saasBg01`…`saasBg19`、`saasFont06`…这类导出式命名
  不表达用途，编号还带空洞；改为一组有名字的角色，读代码即知道该用哪个颜色。
- **令牌装进 `Map<SAColorRole, Color>`，而不是三十余个字段**。逐字段实现需要同步维护
  构造函数、`copyWith`、`lerp`、`toMap` 四份清单，历史上就出现过 `copyWith` 取错字段、
  `toMap` 漏写三个键导致往返丢色的问题；按角色遍历的通用逻辑从结构上消除了这类错误。
- **配置类改为"只描述覆盖项"**。原实现要求把全部颜色都传一遍才能构造配置；
  `SAColorConfig` 允许只下发一个主色，其余回落默认色板。
- **取令牌不再 `!` 强转**。原实现在主题没挂扩展时直接崩溃，现在按亮度回退默认色板。
- **颜色解析容错**。`#000000` 会被当成"解析失败"返回 null、非法字符串抛 `FormatException`
  的问题已修正，`tryParse` / `parse` 两种语义分开。
- **排版接入 `ThemeData`**。原实现只提供静态样式表，主题里的 `textTheme` 仍是框架默认值，
  两套字号并存；现在 `SATextStyles` 覆盖全部槽位并由 `SATypography` 注入主题。
- **明暗主题共用一份构建逻辑**。原来 light / dark 两个方法逐行复制，改一处必须记得改另一处。

---

## 📄 版本与迁移

- 当前为本地 `path` 依赖，稳定后迁移到远程 Git 仓库，业务代码无需改动。
- `SAAppTheme.lightTheme` / `SAAppTheme.darkTheme` 保持可用，可直接替换原有调用。
- 注意 `SAColors.backgroundLight` / `backgroundDark` 的取值已调整为"页面底色"，
  与 `surfaceLight` / `surfaceDark`（容器底色）分层，卡片才与背景有对比。
