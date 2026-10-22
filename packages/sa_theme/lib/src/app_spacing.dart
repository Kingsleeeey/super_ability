/// 应用间距规范。
///
/// 统一使用 4 的倍数作为间距基准，确保视觉一致性。
class SASpacing {
  SASpacing._();

  /// 2px - 极小间距
  static const double xxs = 2;

  /// 4px - 特小间距
  static const double xs = 4;

  /// 8px - 小间距
  static const double sm = 8;

  /// 12px - 中小间距
  static const double md = 12;

  /// 16px - 中间距
  static const double lg = 16;

  /// 20px - 中大间距
  static const double xl = 20;

  /// 24px - 大间距
  static const double xxl = 24;

  /// 32px - 特大间距
  static const double xxxl = 32;

  /// 48px - 超大间距
  static const double xxxxl = 48;
}

/// 应用圆角规范。
class SARadius {
  SARadius._();

  /// 4px - 小圆角
  static const double sm = 4;

  /// 8px - 中圆角
  static const double md = 8;

  /// 12px - 大圆角
  static const double lg = 12;

  /// 16px - 特大圆角
  static const double xl = 16;

  /// 999px - 全圆角（胶囊形）
  static const double full = 999;
}
