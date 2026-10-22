import 'package:dio/dio.dart';

/// 自动过滤 query / body 中 null 参数的拦截器。
///
/// 如果业务需要保留 null 字段，可在 [RequestOptions.extra] 中设置
/// `sa_keep_null: true`。
class NullParameterInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final keepNull = options.extra['sa_keep_null'] == true;
    if (keepNull) {
      handler.next(options);
      return;
    }

    options.queryParameters = _removeNull(options.queryParameters);
    if (options.data is Map<String, dynamic>) {
      options.data = _removeNull(options.data as Map<String, dynamic>);
    }
    handler.next(options);
  }

  Map<String, dynamic> _removeNull(Map<String, dynamic> map) {
    return Map<String, dynamic>.fromEntries(
      map.entries.where((entry) => entry.value != null),
    );
  }
}
