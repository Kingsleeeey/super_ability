import 'dart:convert';

import 'package:dio/dio.dart';

/// 控制台日志拦截器。
///
/// 只在 Debug 模式下输出，release 模式不会打印任何内容。
class SaLogInterceptor extends Interceptor {
  /// 创建一个 [SaLogInterceptor]。
  SaLogInterceptor({this.logPrint = _print})
    : _encoder = const JsonEncoder.withIndent('  ');

  /// 日志输出回调，方便业务方接入自定义日志库。
  final void Function(String message) logPrint;

  final JsonEncoder _encoder;

  static void _print(String message) {
    // ignore: avoid_print -- 仅用于调试日志
    print(message);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log('┌────── Request ──────');
    _log('│ ${options.method} ${options.uri}');
    _log('│ headers: ${_encoder.convert(options.headers)}');
    if (options.queryParameters.isNotEmpty) {
      _log('│ query: ${_encoder.convert(options.queryParameters)}');
    }
    if (options.data != null) {
      _log('│ body: ${_encoder.convert(options.data)}');
    }
    _log('└────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log('┌────── Response ──────');
    _log('│ ${response.statusCode} ${response.requestOptions.uri}');
    _log('│ body: ${_encoder.convert(response.data)}');
    _log('└──────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log('┌────── Error ──────');
    _log('│ ${err.type} ${err.requestOptions.uri}');
    _log('│ message: ${err.message}');
    if (err.response != null) {
      _log('│ statusCode: ${err.response?.statusCode}');
      _log('│ body: ${_encoder.convert(err.response?.data)}');
    }
    _log('└────────────────────');
    handler.next(err);
  }

  void _log(String message) {
    assert(() {
      logPrint(message);
      return true;
    }(), 'Debug log only');
  }
}
