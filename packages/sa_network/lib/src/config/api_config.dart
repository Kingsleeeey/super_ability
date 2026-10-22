import 'package:dio/dio.dart';

/// `DioClient` 的通用配置。
///
/// 业务方通过该配置注入 baseUrl、超时时间、默认请求头等，
/// 网络库本身不耦合任何业务参数。
class ApiConfig {
  /// 创建一个 [ApiConfig]。
  const ApiConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.sendTimeout = const Duration(seconds: 15),
    this.headers = const {},
    this.followRedirects = true,
  });

  /// 基础请求地址。
  final String baseUrl;

  /// 连接超时。
  final Duration connectTimeout;

  /// 接收超时。
  final Duration receiveTimeout;

  /// 发送超时。
  final Duration sendTimeout;

  /// 默认请求头。
  final Map<String, dynamic> headers;

  /// 是否跟随 302 重定向。
  final bool followRedirects;

  /// 转换为 Dio 的 [BaseOptions]。
  BaseOptions toBaseOptions() {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      headers: <String, dynamic>{
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        ...headers,
      },
      followRedirects: followRedirects,
    );
  }
}
