/// URL 工具函数。
///
/// 提供编码、拼接、参数处理等常用 URL 操作。
class UrlUtils {
  UrlUtils._();

  /// 拼接基础地址和路径，自动处理斜杠。
  ///
  /// ```dart
  /// UrlUtils.join('https://api.example.com', '/users/1');
  /// // => 'https://api.example.com/users/1'
  /// ```
  static String join(String base, String path) {
    final trimmedBase = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;
    final trimmedPath = path.startsWith('/')
        ? path.substring(1)
        : path;
    return '$trimmedBase/$trimmedPath';
  }

  /// 将 Map 转换为 URL 查询字符串。
  ///
  /// 自动进行 URL 编码，过滤 null 值。
  /// ```dart
  /// UrlUtils.toQueryString({'page': 1, 'size': 10});
  /// // => 'page=1&size=10'
  /// ```
  static String toQueryString(Map<String, dynamic> params) {
    final entries = params.entries
        .where((e) => e.value != null)
        .map((e) {
          final key = Uri.encodeComponent(e.key);
          final value = Uri.encodeComponent(e.value.toString());
          return '$key=$value';
        });
    return entries.join('&');
  }

  /// 向 URL 追加查询参数。
  ///
  /// ```dart
  /// UrlUtils.appendQuery('https://api.com/users', {'page': 1});
  /// // => 'https://api.com/users?page=1'
  /// ```
  static String appendQuery(String url, Map<String, dynamic> params) {
    if (params.isEmpty) return url;
    final separator = url.contains('?') ? '&' : '?';
    return '$url$separator${toQueryString(params)}';
  }
}
