/// 字符串扩展方法。
extension StringExtensions on String {
  /// 首字母大写。
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// 脱敏处理（如手机号 138****1234）。
  String desensitize({
    int prefixLen = 3,
    int suffixLen = 4,
    String mask = '*',
  }) {
    if (length <= prefixLen + suffixLen) return this;
    final prefix = substring(0, prefixLen);
    final suffix = substring(length - suffixLen);
    final middle = mask * (length - prefixLen - suffixLen);
    return '$prefix$middle$suffix';
  }

  /// 是否为空或仅包含空白字符。
  bool get isBlank => trim().isEmpty;

  /// 是否不为空且包含非空白字符。
  bool get isNotBlank => !isBlank;
}
