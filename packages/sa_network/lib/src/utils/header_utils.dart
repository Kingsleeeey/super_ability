import 'dart:convert';

/// HTTP 请求头工具函数。
///
/// 提供常用的请求头构造、解析、编码等操作。
class HeaderUtils {
  HeaderUtils._();

  /// 构造 Basic Auth 请求头值。
  ///
  /// ```dart
  /// HeaderUtils.basicAuth('username', 'password');
  /// // => 'Basic dXNlcm5hbWU6cGFzc3dvcmQ='
  /// ```
  static String basicAuth(String username, String password) {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    return 'Basic $credentials';
  }

  /// 构造 Bearer Token 请求头值。
  ///
  /// ```dart
  /// HeaderUtils.bearer('eyJhbGciOiJIUzI1NiIs...');
  /// // => 'Bearer eyJhbGciOiJIUzI1NiIs...'
  /// ```
  static String bearer(String token) => 'Bearer $token';

  /// 从请求头值中提取 Token（去除 Bearer 前缀）。
  ///
  /// ```dart
  /// HeaderUtils.extractToken('Bearer abc123');
  /// // => 'abc123'
  /// ```
  static String? extractToken(String? authHeader) {
    if (authHeader == null || authHeader.isEmpty) return null;
    final parts = authHeader.split(' ');
    return parts.length > 1 ? parts.last : authHeader;
  }

  /// 构造 multipart/form-data 的 Content-Type 头（含 boundary）。
  ///
  /// [boundary] 为分隔符，通常由 Dio 自动生成。
  static String multipart(String boundary) {
    return 'multipart/form-data; boundary=$boundary';
  }

  /// 构造标准的 JSON 请求头。
  static Map<String, String> get jsonHeaders => const <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      };

  /// 构造标准的表单请求头。
  static Map<String, String> get formHeaders => const <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      };
}
