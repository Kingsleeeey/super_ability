import 'package:flutter/material.dart';
import 'package:sa_theme/src/app_palette.dart';

/// 主题设计令牌，通过 [ThemeExtension] 随 [ThemeData] 一起下发。
///
/// 与静态的 `SAColors` 不同，令牌是**与当前亮度匹配的那一套颜色**，
/// 明暗切换、服务端换肤都只改这里，业务代码无需感知。
@immutable
class SAThemeTokens extends ThemeExtension<SAThemeTokens> {
  /// 以指定色板构造令牌。
  const SAThemeTokens({required this.palette});

  /// 从最近的主题中读取令牌。
  ///
  /// 未安装扩展时（例如单元测试里的裸 [ThemeData]、或第三方库自带的主题）
  /// 按当前亮度回退到默认色板，而不是抛异常。
  factory SAThemeTokens.of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<SAThemeTokens>() ??
        SAThemeTokens(palette: SAPalette.defaultFor(theme.brightness));
  }

  /// 亮色默认令牌。
  static const SAThemeTokens light = SAThemeTokens(palette: SAPalette.light);

  /// 暗色默认令牌。
  static const SAThemeTokens dark = SAThemeTokens(palette: SAPalette.dark);

  /// 当前生效的语义色板。
  final SAPalette palette;

  /// 应用动态配色后返回新令牌。
  SAThemeTokens withConfig(SAColorConfig config, Brightness brightness) {
    if (config.isEmpty) return this;
    return SAThemeTokens(palette: palette.applyConfig(config, brightness));
  }

  @override
  SAThemeTokens copyWith({SAPalette? palette}) {
    return SAThemeTokens(palette: palette ?? this.palette);
  }

  @override
  SAThemeTokens lerp(ThemeExtension<SAThemeTokens>? other, double t) {
    if (other is! SAThemeTokens) return this;
    return SAThemeTokens(palette: palette.lerp(other.palette, t));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SAThemeTokens && palette == other.palette;

  @override
  int get hashCode => palette.hashCode;
}

/// [BuildContext] 上的主题令牌访问扩展。
extension SAThemeX on BuildContext {
  /// 当前主题令牌。
  SAThemeTokens get tokens => SAThemeTokens.of(this);

  /// 当前主题语义色板，等价于 `context.tokens.palette`。
  SAPalette get colors => tokens.palette;

  /// 当前主题的文字排版。
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// 当前是否为暗色模式。
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
