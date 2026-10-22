import 'dart:async';

import 'package:dio/dio.dart';

/// 重试判定条件。
///
/// 业务方可以自定义哪些错误需要重试。
typedef RetryEvaluator = bool Function(DioException error, int attempt);

/// 失败请求自动重试拦截器。
class RetryInterceptor extends Interceptor {
  /// 创建一个 [RetryInterceptor]。
  RetryInterceptor({
    required this._dio,
    this.maxAttempts = 3,
    this.retryDelay = const Duration(seconds: 1),
    RetryEvaluator? retryEvaluator,
  }) : _retryEvaluator = retryEvaluator ?? _defaultRetryEvaluator;

  /// 最大重试次数。
  final int maxAttempts;

  /// 重试间隔基数，实际延迟为 `retryDelay * attempt`。
  final Duration retryDelay;

  final Dio _dio;
  final RetryEvaluator _retryEvaluator;

  static bool _defaultRetryEvaluator(DioException error, int attempt) {
    // 仅对网络层错误进行重试，业务 4xx/5xx 不重试。
    return error.type != DioExceptionType.badResponse &&
        error.type != DioExceptionType.cancel;
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final attempt = (extra['sa_retry_attempt'] as int? ?? 0) + 1;

    if (attempt > maxAttempts || !_retryEvaluator(err, attempt)) {
      handler.next(err);
      return;
    }

    await Future<void>.delayed(retryDelay * attempt);

    final options = err.requestOptions.copyWith(
      extra: {...extra, 'sa_retry_attempt': attempt},
    );

    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}
