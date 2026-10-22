/// 网络/业务异常基类。
class ApiException implements Exception {
  /// 创建一个 API 异常。
  ApiException(this.message, {this.code, this.stackTrace});

  /// 错误信息。
  final String message;

  /// 错误码（HTTP 状态码或业务码）。
  final int? code;

  /// 堆栈信息。
  final StackTrace? stackTrace;

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}

/// 网络连接异常。
class NetworkException extends ApiException {
  /// 创建一个网络异常。
  NetworkException([super.message = '网络连接失败，请检查网络设置']);
}

/// 请求超时异常。
class TimeoutException extends ApiException {
  /// 创建一个超时异常。
  TimeoutException([super.message = '请求超时，请稍后重试']);
}

/// 未授权异常（Token 过期等）。
class UnauthorizedException extends ApiException {
  /// 创建一个未授权异常。
  UnauthorizedException([super.message = '登录已过期，请重新登录']) : super(code: 401);
}

/// 服务端异常。
class ServerException extends ApiException {
  /// 创建一个服务端异常。
  ServerException([super.message = '服务器异常，请稍后重试']) : super(code: 500);
}
