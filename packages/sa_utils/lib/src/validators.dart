/// 通用输入校验工具。
class Validators {
  Validators._();

  /// 校验邮箱格式。
  static bool isValidEmail(String value) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(value);
  }

  /// 校验手机号格式（中国大陆）。
  static bool isValidPhone(String value) {
    final regex = RegExp(r'^1[3-9]\d{9}$');
    return regex.hasMatch(value);
  }

  /// 校验密码强度（至少 8 位，包含字母和数字）。
  static bool isValidPassword(String value) {
    if (value.length < 8) return false;
    final hasLetter = RegExp('[a-zA-Z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    return hasLetter && hasDigit;
  }

  /// 校验非空。
  static String? required(String? value, [String message = '此项为必填']) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  /// 校验邮箱并返回错误信息。
  static String? email(String? value) {
    if (value == null || value.isEmpty) return '请输入邮箱';
    if (!isValidEmail(value)) return '邮箱格式不正确';
    return null;
  }

  /// 校验手机号并返回错误信息。
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return '请输入手机号';
    if (!isValidPhone(value)) return '手机号格式不正确';
    return null;
  }
}
