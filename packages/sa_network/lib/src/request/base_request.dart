import 'package:dio/dio.dart';

/// 通用请求参数封装。
///
/// 业务方通过继承该类，封装具体 API 的请求参数。
/// 提供统一的参数校验、转换能力，避免每个接口重复写参数组装逻辑。
abstract class BaseRequest {
  /// 创建一个 [BaseRequest]。
  const BaseRequest();

  /// 请求路径（不含 baseUrl）。
  String get path;

  /// 请求方法，默认 GET。
  String get method => 'GET';

  /// 请求体（仅 POST/PUT/PATCH 使用）。
  Object? get body => null;

  /// URL 查询参数。
  Map<String, dynamic>? get queryParameters => null;

  /// 自定义请求头（会覆盖默认配置中的同名头）。
  Map<String, dynamic>? get headers => null;

  /// 转换为 Dio 的 [Options]。
  Options toOptions() {
    return Options(
      method: method,
      headers: headers,
    );
  }

  /// 转换为 Dio 请求所需的参数 Map。
  Map<String, dynamic> toRequestParams() {
    return <String, dynamic>{
      'path': path,
      'method': method,
      if (body != null) 'data': body,
      if (queryParameters != null && queryParameters!.isNotEmpty)
        'queryParameters': queryParameters,
      if (headers != null && headers!.isNotEmpty) 'headers': headers,
    };
  }
}
