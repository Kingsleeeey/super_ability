import 'package:flutter/material.dart';
import 'package:sa_theme/src/app_palette.dart';
import 'package:sa_theme/src/app_spacing.dart';
import 'package:sa_theme/src/app_theme_tokens.dart';
import 'package:sa_theme/src/app_typography.dart';

/// 应用主题构建器。
///
/// 亮色与暗色共用同一份组件主题逻辑，只在色板与亮度上不同，
/// 因此改一处即可同时作用于两种模式。
class SAAppTheme {
  SAAppTheme._();

  /// 亮色主题（默认色板）。
  static ThemeData get lightTheme => light();

  /// 暗色主题（默认色板）。
  static ThemeData get darkTheme => dark();

  /// 构建亮色主题。
  ///
  /// [config] 为服务端下发或本地缓存的动态配色，只覆盖它包含的角色，
  /// 其余仍使用 [SAPalette.light]。
  static ThemeData light({SAColorConfig? config}) =>
      _build(Brightness.light, SAPalette.light, config);

  /// 构建暗色主题。
  static ThemeData dark({SAColorConfig? config}) =>
      _build(Brightness.dark, SAPalette.dark, config);

  /// 使用自定义色板构建主题，用于整包替换配色方案的业务。
  static ThemeData fromPalette({
    required SAPalette palette,
    required Brightness brightness,
  }) => _build(brightness, palette, null);

  static ThemeData _build(
    Brightness brightness,
    SAPalette basePalette,
    SAColorConfig? config,
  ) {
    final palette = config == null
        ? basePalette
        : basePalette.applyConfig(config, brightness);
    final tokens = SAThemeTokens(palette: palette);
    final textTheme = SATypography.build(palette: palette);
    final colorScheme = _colorScheme(brightness, palette);

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: palette.background,
      extensions: <ThemeExtension<dynamic>>[tokens],
      iconTheme: IconThemeData(color: palette.iconDefault),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: palette.surface,
        foregroundColor: palette.textPrimary,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: palette.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SARadius.lg),
          side: BorderSide(color: palette.border, width: 0.5),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SARadius.xl),
        ),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: palette.textPrimary,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: palette.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          disabledBackgroundColor: palette.primarySoft,
          disabledForegroundColor: palette.textTertiary,
          shape: _rounded(SARadius.lg),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary,
          side: BorderSide(color: palette.border),
          shape: _rounded(SARadius.lg),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.link,
          shape: _rounded(SARadius.md),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SASpacing.lg,
          vertical: SASpacing.md,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: palette.textTertiary),
        errorStyle: textTheme.bodySmall?.copyWith(color: palette.error),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: palette.textSecondary,
        ),
        border: _inputBorder(palette.border),
        enabledBorder: _inputBorder(palette.border),
        focusedBorder: _inputBorder(palette.primary, width: 1.5),
        errorBorder: _inputBorder(palette.error),
        focusedErrorBorder: _inputBorder(palette.error, width: 1.5),
      ),
      dividerTheme: DividerThemeData(
        color: palette.divider,
        thickness: 0.5,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.iconDefault,
        textColor: palette.textPrimary,
        selectedTileColor: palette.primarySoft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SARadius.md),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surfaceMuted,
        selectedColor: palette.primarySoft,
        labelStyle: textTheme.labelMedium?.copyWith(color: palette.textPrimary),
        side: BorderSide(color: palette.border, width: 0.5),
        shape: _rounded(SARadius.md),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: palette.textInverse,
        ),
        actionTextColor: palette.primarySoft,
        behavior: SnackBarBehavior.floating,
        shape: _rounded(SARadius.md),
      ),
    );
  }

  /// 以种子色生成完整 tonal palette，再用设计令牌覆盖 Material 角色，
  /// 既保留 Material 3 的层次关系，又保证关键槽位取自设计稿。
  static ColorScheme _colorScheme(Brightness brightness, SAPalette palette) {
    return ColorScheme.fromSeed(
      seedColor: palette.primary,
      brightness: brightness,
    ).copyWith(
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      primaryContainer: palette.primarySoft,
      onPrimaryContainer: palette.textPrimary,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      surfaceContainerHighest: palette.surfaceMuted,
      error: palette.error,
      onError: palette.onPrimary,
      outline: palette.border,
      outlineVariant: palette.divider,
      scrim: palette.overlay,
    );
  }

  static RoundedRectangleBorder _rounded(double radius) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(SARadius.lg),
    );
  }
}
