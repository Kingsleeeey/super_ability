import 'package:flutter/material.dart';

/// 原始色值表（设计稿取色）。
///
/// 这里只存放"颜色本身"，不表达用途。业务代码请优先通过 `SAColorRole` +
/// `SAPalette`（或 `context.colors`）按语义取色，这样暗色模式与服务端换肤
/// 才能自动生效。
class SAColors {
  SAColors._();

  // --- 主色 ---

  /// 主色
  static const Color primary = Color(0xFF6750A4);

  /// 主色变体 - 亮
  static const Color primaryLight = Color(0xFFD0BCFF);

  /// 主色变体 - 暗
  static const Color primaryDark = Color(0xFF4F378B);

  /// 主色之上的文字与图标（亮色模式）
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// 主色之上的文字与图标（暗色模式）
  static const Color onPrimaryDark = Color(0xFF381E72);

  /// 主色浅底，用于选中态背景（亮色模式）
  static const Color primarySoftLight = Color(0xFFEADDFF);

  /// 主色浅底，用于选中态背景（暗色模式）
  static const Color primarySoftDark = Color(0xFF4F378B);

  // --- 辅助色 ---

  /// 次要色
  static const Color secondary = Color(0xFF625B71);

  /// 第三色
  static const Color tertiary = Color(0xFF7D5260);

  // --- 语义色 ---

  /// 成功
  static const Color success = Color(0xFF4CAF50);

  /// 成功 - 暗色模式加深提亮后的可读版本
  static const Color successDark = Color(0xFF79C97E);

  /// 警告
  static const Color warning = Color(0xFFFFC107);

  /// 警告 - 暗色
  static const Color warningDark = Color(0xFFFFD166);

  /// 错误
  static const Color error = Color(0xFFB3261E);

  /// 错误 - 暗色
  static const Color errorDark = Color(0xFFFFB4AB);

  /// 信息
  static const Color info = Color(0xFF2196F3);

  /// 信息 - 暗色
  static const Color infoDark = Color(0xFF7FC3FF);

  // --- 中性色 ---

  /// 背景色 - 页面底色（亮色模式）
  static const Color backgroundLight = Color(0xFFF7F2FA);

  /// 背景色 - 页面底色（暗色模式）
  static const Color backgroundDark = Color(0xFF141218);

  /// 表面色 - 卡片/容器底色（亮色模式）
  static const Color surfaceLight = Color(0xFFFFFBFE);

  /// 表面色 - 卡片/容器底色（暗色模式）
  static const Color surfaceDark = Color(0xFF1C1B1F);

  /// 次级容器底色（亮色模式）
  static const Color surfaceMutedLight = Color(0xFFF3EDF7);

  /// 次级容器底色（暗色模式）
  static const Color surfaceMutedDark = Color(0xFF2B2930);

  /// 文字主色 - 亮色模式
  static const Color textPrimaryLight = Color(0xFF1C1B1F);

  /// 文字主色 - 暗色模式
  static const Color textPrimaryDark = Color(0xFFE6E1E5);

  /// 文字次要色 - 亮色模式
  static const Color textSecondaryLight = Color(0xFF49454F);

  /// 文字次要色 - 暗色模式
  static const Color textSecondaryDark = Color(0xFFCAC4D0);

  /// 三级文字/占位/禁用 - 亮色模式
  static const Color textTertiaryLight = Color(0xFF79747E);

  /// 三级文字/占位/禁用 - 暗色模式
  static const Color textTertiaryDark = Color(0xFF938F99);

  /// 描边 - 亮色模式
  static const Color outlineLight = Color(0xFFCAC4D0);

  /// 描边 - 暗色模式
  static const Color outlineDark = Color(0xFF49454F);

  /// 分割线
  static const Color divider = Color(0xFFE0E0E0);

  /// 分割线 - 暗色
  static const Color dividerDark = Color(0xFF49454F);

  /// 遮罩层
  static const Color scrim = Color(0x66000000);

  /// 遮罩层 - 暗色模式加深
  static const Color scrimDark = Color(0x99000000);

  // --- 渐变 ---

  /// 主渐变起始色（亮色模式）
  static const Color gradientStartLight = primary;

  /// 主渐变结束色（亮色模式）
  static const Color gradientEndLight = Color(0xFF9C6ADE);

  /// 主渐变起始色（暗色模式）
  static const Color gradientStartDark = primaryDark;

  /// 主渐变结束色（暗色模式）
  static const Color gradientEndDark = Color(0xFF7A4FCF);
}
