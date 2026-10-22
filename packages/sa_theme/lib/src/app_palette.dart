import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sa_theme/src/app_colors.dart';

/// 主题颜色角色。
///
/// 每个角色描述"颜色的用途"而不是"颜色本身"，亮色与暗色模式各有一套取值。
/// 枚举名同时作为与服务端 JSON、本地存储交互的键名，新增角色只需在此追加，
/// 序列化与合并逻辑无需修改。
enum SAColorRole {
  /// 品牌主色，用于主按钮、强调元素
  primary,

  /// 主色之上的文字与图标
  onPrimary,

  /// 主色浅底，用于选中态背景、次级容器
  primarySoft,

  /// 页面底色
  background,

  /// 卡片、表单等容器底色
  surface,

  /// 次级容器底色，用于输入框、分组区块
  surfaceMuted,

  /// 遮罩层（半透明）
  overlay,

  /// 一级文字
  textPrimary,

  /// 二级文字
  textSecondary,

  /// 三级文字、占位与禁用态
  textTertiary,

  /// 深色容器上的反色文字
  textInverse,

  /// 描边
  border,

  /// 分割线
  divider,

  /// 图标默认色
  iconDefault,

  /// 图标选中色
  iconActive,

  /// 成功、完成
  success,

  /// 警告、提醒
  warning,

  /// 错误、失败、必填
  error,

  /// 信息、提示
  info,

  /// 可点击链接
  link,

  /// 主渐变起始色
  gradientStart,

  /// 主渐变结束色
  gradientEnd,
}

/// 颜色解析工具。
///
/// 兼容 `#RGB`、`#RGBA`、`#RRGGBB`、`#AARRGGBB`、不带 `#` 的同形字符串，
/// 以及 `int` 色值与 [Color] 实例。
class SAColorUtils {
  SAColorUtils._();

  /// 解析颜色，无法识别时返回 null。
  static Color? tryParse(Object? value) {
    if (value == null) return null;
    if (value case final Color color) return color;
    if (value is int) return Color(value);
    if (value case final String raw) {
      final hex = raw.trim().replaceFirst('#', '').replaceFirst('0x', '');
      final argb = switch (hex.length) {
        3 => 'ff${_expand(hex)}',
        4 => _expand(hex),
        6 => 'ff$hex',
        8 => hex,
        _ => null,
      };
      if (argb == null) return null;
      final parsed = int.tryParse(argb, radix: 16);
      return parsed == null ? null : Color(parsed);
    }
    return null;
  }

  /// 解析颜色，无法识别时抛出 [FormatException]。
  static Color parse(Object? value) {
    final color = tryParse(value);
    if (color == null) {
      throw FormatException('无法解析为颜色值', value);
    }
    return color;
  }

  /// 将颜色输出为 `#AARRGGBB` 字符串。
  static String toHex(Color color) {
    final argb = color.toARGB32();
    return '#${argb.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  /// 把 `#RGB` 这类缩写展开成完整十六进制。
  static String _expand(String hex) {
    final buffer = StringBuffer();
    for (final char in hex.split('')) {
      buffer.write('$char$char');
    }
    return buffer.toString();
  }
}

/// 一套完整的语义色板。
///
/// 内部以 [SAColorRole] 为键保存颜色，因此覆盖合并、序列化、插值都是通用
/// 逻辑，不会像逐字段实现那样出现漏拷贝或复制粘贴写错字段的问题。
@immutable
class SAPalette {
  /// 直接以角色映射构造色板。
  const SAPalette({required this.colors});

  /// 从 JSON 构造，缺省角色回退到 [SAPalette.light]。
  ///
  /// 未知键名与无法解析的值会被忽略。
  factory SAPalette.fromJson(Map<String, dynamic> json) {
    return light.withOverrides(_rolesFrom(json));
  }

  /// 亮色模式默认色板。
  static const SAPalette light = SAPalette(
    colors: {
      SAColorRole.primary: SAColors.primary,
      SAColorRole.onPrimary: SAColors.onPrimary,
      SAColorRole.primarySoft: SAColors.primarySoftLight,
      SAColorRole.background: SAColors.backgroundLight,
      SAColorRole.surface: SAColors.surfaceLight,
      SAColorRole.surfaceMuted: SAColors.surfaceMutedLight,
      SAColorRole.overlay: SAColors.scrim,
      SAColorRole.textPrimary: SAColors.textPrimaryLight,
      SAColorRole.textSecondary: SAColors.textSecondaryLight,
      SAColorRole.textTertiary: SAColors.textTertiaryLight,
      SAColorRole.textInverse: SAColors.surfaceLight,
      SAColorRole.border: SAColors.outlineLight,
      SAColorRole.divider: SAColors.divider,
      SAColorRole.iconDefault: SAColors.textSecondaryLight,
      SAColorRole.iconActive: SAColors.primary,
      SAColorRole.success: SAColors.success,
      SAColorRole.warning: SAColors.warning,
      SAColorRole.error: SAColors.error,
      SAColorRole.info: SAColors.info,
      SAColorRole.link: SAColors.primaryDark,
      SAColorRole.gradientStart: SAColors.gradientStartLight,
      SAColorRole.gradientEnd: SAColors.gradientEndLight,
    },
  );

  /// 暗色模式默认色板。
  static const SAPalette dark = SAPalette(
    colors: {
      SAColorRole.primary: SAColors.primaryLight,
      SAColorRole.onPrimary: SAColors.onPrimaryDark,
      SAColorRole.primarySoft: SAColors.primarySoftDark,
      SAColorRole.background: SAColors.backgroundDark,
      SAColorRole.surface: SAColors.surfaceDark,
      SAColorRole.surfaceMuted: SAColors.surfaceMutedDark,
      SAColorRole.overlay: SAColors.scrimDark,
      SAColorRole.textPrimary: SAColors.textPrimaryDark,
      SAColorRole.textSecondary: SAColors.textSecondaryDark,
      SAColorRole.textTertiary: SAColors.textTertiaryDark,
      SAColorRole.textInverse: SAColors.surfaceDark,
      SAColorRole.border: SAColors.outlineDark,
      SAColorRole.divider: SAColors.dividerDark,
      SAColorRole.iconDefault: SAColors.textTertiaryDark,
      SAColorRole.iconActive: SAColors.primaryLight,
      SAColorRole.success: SAColors.successDark,
      SAColorRole.warning: SAColors.warningDark,
      SAColorRole.error: SAColors.errorDark,
      SAColorRole.info: SAColors.infoDark,
      SAColorRole.link: SAColors.primaryLight,
      SAColorRole.gradientStart: SAColors.gradientStartDark,
      SAColorRole.gradientEnd: SAColors.gradientEndDark,
    },
  );

  /// 角色到颜色的映射。
  final Map<SAColorRole, Color> colors;

  /// 按角色取色，缺失的角色回退到 [SAPalette.light] 的同名色。
  Color operator [](SAColorRole role) => colors[role] ?? light.colors[role]!;

  /// 品牌主色
  Color get primary => this[SAColorRole.primary];

  /// 主色之上的文字与图标
  Color get onPrimary => this[SAColorRole.onPrimary];

  /// 主色浅底
  Color get primarySoft => this[SAColorRole.primarySoft];

  /// 页面底色
  Color get background => this[SAColorRole.background];

  /// 容器底色
  Color get surface => this[SAColorRole.surface];

  /// 次级容器底色
  Color get surfaceMuted => this[SAColorRole.surfaceMuted];

  /// 遮罩层
  Color get overlay => this[SAColorRole.overlay];

  /// 一级文字
  Color get textPrimary => this[SAColorRole.textPrimary];

  /// 二级文字
  Color get textSecondary => this[SAColorRole.textSecondary];

  /// 三级文字、占位与禁用态
  Color get textTertiary => this[SAColorRole.textTertiary];

  /// 深色容器上的反色文字
  Color get textInverse => this[SAColorRole.textInverse];

  /// 描边
  Color get border => this[SAColorRole.border];

  /// 分割线
  Color get divider => this[SAColorRole.divider];

  /// 图标默认色
  Color get iconDefault => this[SAColorRole.iconDefault];

  /// 图标选中色
  Color get iconActive => this[SAColorRole.iconActive];

  /// 成功、完成
  Color get success => this[SAColorRole.success];

  /// 警告、提醒
  Color get warning => this[SAColorRole.warning];

  /// 错误、失败、必填
  Color get error => this[SAColorRole.error];

  /// 信息、提示
  Color get info => this[SAColorRole.info];

  /// 可点击链接
  Color get link => this[SAColorRole.link];

  /// 渐变起始色
  Color get gradientStart => this[SAColorRole.gradientStart];

  /// 渐变结束色
  Color get gradientEnd => this[SAColorRole.gradientEnd];

  /// 主渐变，方向为左上到右下。
  LinearGradient get primaryGradient => LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 是否覆盖了全部角色。
  bool get isComplete => SAColorRole.values.every(colors.containsKey);

  /// 按亮度取默认色板。
  static SAPalette defaultFor(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  /// 返回应用了 [overrides] 的新色板，未提供的角色保持原值。
  SAPalette withOverrides(Map<SAColorRole, Color> overrides) {
    if (overrides.isEmpty) return this;
    return SAPalette(colors: {...colors, ...overrides});
  }

  /// 按 [brightness] 应用 [config] 中的动态配色（服务端换肤入口）。
  SAPalette applyConfig(SAColorConfig config, Brightness brightness) =>
      withOverrides(config.colorsFor(brightness));

  /// 输出 `#AARRGGBB` 字符串映射，用于持久化或下发。
  Map<String, String> toJson() => {
    for (final entry in colors.entries)
      entry.key.name: SAColorUtils.toHex(entry.value),
  };

  /// 色板插值，用于主题过渡动画。
  SAPalette lerp(SAPalette other, double t) {
    if (identical(other, this) || t == 1) return other;
    if (t == 0) return this;
    final lerped = <SAColorRole, Color>{};
    for (final role in SAColorRole.values) {
      lerped[role] = Color.lerp(this[role], other[role], t)!;
    }
    return SAPalette(colors: lerped);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SAPalette && _sameColors(colors, other.colors);

  @override
  int get hashCode => Object.hashAllUnordered([
    for (final entry in colors.entries) Object.hash(entry.key, entry.value),
  ]);

  @override
  String toString() =>
      'SAPalette(${colors.length}/${SAColorRole.values.length} roles)';
}

/// 动态配色配置。
///
/// 只描述"需要覆盖默认色板的角色"，因此可以只下发一个主色，其余保持默认。
/// 典型用法是服务端返回一份 JSON，客户端解析后交给 `SAAppTheme`。
@immutable
class SAColorConfig {
  /// 指定亮色、暗色以及两种模式共用的覆盖项。
  const SAColorConfig({
    this.light = const {},
    this.dark = const {},
    this.flat = const {},
  });

  /// 从 JSON 构造。
  ///
  /// 支持两种结构：
  /// - 分模式：`{"light": {"primary": "#6750A4"}, "dark": {"primary": "#D0BCFF"}}`
  /// - 扁平（两种模式共用）：`{"primary": "#6750A4"}`
  ///
  /// 未知键名与无法解析的值会被忽略，业务无需为服务端字段变更做兼容分支。
  factory SAColorConfig.fromJson(Map<String, dynamic> json) {
    final lightSection = _sectionOf(json, 'light');
    final darkSection = _sectionOf(json, 'dark');
    if (lightSection == null && darkSection == null) {
      return SAColorConfig(flat: _rolesFrom(json));
    }
    return SAColorConfig(
      light: _rolesFrom(lightSection),
      dark: _rolesFrom(darkSection),
    );
  }

  /// 从 JSON 字符串构造。
  factory SAColorConfig.fromJsonString(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map) return const SAColorConfig();
    return SAColorConfig.fromJson(Map<String, dynamic>.from(decoded));
  }

  /// 亮色模式覆盖项。
  final Map<SAColorRole, Color> light;

  /// 暗色模式覆盖项。
  final Map<SAColorRole, Color> dark;

  /// 扁平配置：不区分模式，同时作用于亮色与暗色。
  final Map<SAColorRole, Color> flat;

  /// 是否没有任何覆盖项。
  bool get isEmpty => light.isEmpty && dark.isEmpty && flat.isEmpty;

  /// 覆盖项总数。
  int get length => light.length + dark.length + flat.length;

  /// 取指定亮度下的覆盖项，模式专属配置优先于扁平配置。
  Map<SAColorRole, Color> colorsFor(Brightness brightness) {
    final modeSpecific = brightness == Brightness.dark ? dark : light;
    if (flat.isEmpty) return modeSpecific;
    return {...flat, ...modeSpecific};
  }

  /// 合并两份配置，[other] 优先级更高。
  SAColorConfig combine(SAColorConfig other) {
    return SAColorConfig(
      light: {...light, ...other.light},
      dark: {...dark, ...other.dark},
      flat: {...flat, ...other.flat},
    );
  }

  /// 输出可直接持久化或重新下发的 JSON。
  ///
  /// 纯扁平配置输出为扁平结构；一旦同时存在模式专属项，则合并展开成
  /// `light` / `dark` 两段——重新解析后 `colorsFor` 结果等价。
  Map<String, dynamic> toJson() {
    if (isEmpty) return const {};
    final hasSections = light.isNotEmpty || dark.isNotEmpty;
    if (!hasSections) return _jsonOf(flat);
    return {
      'light': _jsonOf(colorsFor(Brightness.light)),
      'dark': _jsonOf(colorsFor(Brightness.dark)),
    };
  }

  static Map<String, dynamic> _jsonOf(Map<SAColorRole, Color> roles) => {
    for (final entry in roles.entries)
      entry.key.name: SAColorUtils.toHex(entry.value),
  };

  static Map<String, dynamic>? _sectionOf(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = json[key];
    if (value is! Map) return null;
    return Map<String, dynamic>.from(value);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SAColorConfig &&
          _sameColors(light, other.light) &&
          _sameColors(dark, other.dark) &&
          _sameColors(flat, other.flat);

  @override
  int get hashCode => Object.hashAllUnordered([
    for (final map in [light, dark, flat])
      for (final entry in map.entries) Object.hash(entry.key, entry.value),
  ]);

  @override
  String toString() => 'SAColorConfig($length overrides)';
}

/// 逐键比较两张颜色映射是否等价。
bool _sameColors(Map<SAColorRole, Color> a, Map<SAColorRole, Color> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}

/// 按枚举名查找颜色角色，未知键名返回 null。
SAColorRole? _roleByName(String name) {
  for (final role in SAColorRole.values) {
    if (role.name == name) return role;
  }
  return null;
}

/// 从任意 JSON 映射中提取可识别的角色颜色对，未知键与非法值被忽略。
Map<SAColorRole, Color> _rolesFrom(Map<String, dynamic>? json) {
  if (json == null) return const {};
  final roles = <SAColorRole, Color>{};
  for (final entry in json.entries) {
    final role = _roleByName(entry.key);
    final color = SAColorUtils.tryParse(entry.value);
    if (role != null && color != null) roles[role] = color;
  }
  return roles;
}
