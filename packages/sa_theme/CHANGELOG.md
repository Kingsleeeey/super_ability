# 更新日志

遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 与语义化版本。

## 0.1.0

### 新增

- `SAColorRole`：22 个语义颜色角色，枚举名即 JSON 键，新增角色无需改动序列化逻辑。
- `SAPalette`：以角色为键的色板，内置 `light` / `dark` 默认值，支持部分覆盖、序列化往返、按角色插值。
- `SAColorConfig`：服务端动态配色，支持分模式与扁平两种 JSON 结构，未知键与非法值自动忽略。
- `SAColorUtils`：容错颜色解析（`#RGB` / `#RGBA` / `#RRGGBB` / `#AARRGGBB` / 整数 / `Color`）与十六进制输出。
- `SAThemeTokens`（`ThemeExtension`）与 `context.colors` / `context.tokens` / `context.isDarkMode` / `context.textTheme`。
- `SATypography`：把排版令牌组装成 `TextTheme` 并接入 `ThemeData`。
- `SAAppTheme.light(config:)` / `dark(config:)` / `fromPalette(...)`。
- `SATextStyles.titleLarge` / `titleMedium` / `titleSmall`，补全 `TextTheme` 全部 15 个槽位。
- `test/` 下色板、配色配置、颜色解析与主题构建的单元及组件测试。

### 变更

- `SAAppTheme` 的明暗主题合并为同一份组件主题构建逻辑，不再逐行复制。
- `ColorScheme` 关键槽位（primary / surface / outline / error / scrim 等）显式取自色板。
- `SAColors.backgroundLight` / `backgroundDark` 调整为"页面底色"，与 `surfaceLight` / `surfaceDark` 分层，使卡片与背景产生对比。
- AppBar 增加 `scrolledUnderElevation: 0`，滚动时不再叠加 Material 3 色调。

### 兼容

- 保留 `SAColors`、`SATextStyles`、`SASpacing`、`SARadius` 与 `SAAppTheme.lightTheme` / `darkTheme`，既有调用无需改动。

## 0.0.1

- 初始版本：静态色值表 `SAColors`、排版令牌 `SATextStyles`、间距规范 `SASpacing` / `SARadius`、`SAAppTheme` 明暗主题。
