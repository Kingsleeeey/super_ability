import 'package:flutter/material.dart';
import 'package:sa_theme/src/app_palette.dart';
import 'package:sa_theme/src/app_text_styles.dart';

/// 由排版令牌构建 Material [TextTheme]。
///
/// [SATextStyles] 覆盖了 TextTheme 的全部槽位，因此
/// `Theme.of(context).textTheme` 与业务代码直接使用 `SATextStyles`
/// 得到的是同一套字号，不会出现两套排版并存。
class SATypography {
  SATypography._();

  /// 构建 [TextTheme]，文字颜色取 [palette] 的一级文字色。
  ///
  /// 组件需要更弱的文字色时自行 `copyWith(color: ...)`，
  /// 排版令牌本身保持无颜色，便于跨明暗模式复用。
  static TextTheme build({required SAPalette palette}) {
    final textColor = palette.textPrimary;
    return const TextTheme(
      displayLarge: SATextStyles.displayLarge,
      displayMedium: SATextStyles.displayMedium,
      displaySmall: SATextStyles.displaySmall,
      headlineLarge: SATextStyles.headlineLarge,
      headlineMedium: SATextStyles.headlineMedium,
      headlineSmall: SATextStyles.headlineSmall,
      titleLarge: SATextStyles.titleLarge,
      titleMedium: SATextStyles.titleMedium,
      titleSmall: SATextStyles.titleSmall,
      bodyLarge: SATextStyles.bodyLarge,
      bodyMedium: SATextStyles.bodyMedium,
      bodySmall: SATextStyles.bodySmall,
      labelLarge: SATextStyles.labelLarge,
      labelMedium: SATextStyles.labelMedium,
      labelSmall: SATextStyles.labelSmall,
    ).apply(bodyColor: textColor, displayColor: textColor);
  }
}
