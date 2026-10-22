/// 通用响应解析器接口。
///
/// 业务方通过实现该接口，将 Dio 原始响应转换为自己项目的标准响应。
/// 这样网络库无需关心业务码字段名（如 code/status/errno 等）以及数据结构。
abstract class ApiResponseParser<T> {
  /// 将 Dio 返回的原始 [data] 解析为业务数据。
  ///
  /// 如果解析失败，应抛出 `FormatException` 或 `ApiException`。
  T parse(dynamic data);
}

/// 统一 API 响应封装。
sealed class ApiResponse<T> {
  const ApiResponse();

  /// 是否成功。
  bool get isSuccess => this is ApiSuccess<T>;

  /// 是否失败。
  bool get isError => this is ApiError;

  /// 获取数据，失败时返回 null。
  T? get dataOrNull;
}

/// 成功响应。
class ApiSuccess<T> extends ApiResponse<T> {
  /// 创建一个成功响应。
  const ApiSuccess(this.data, {this.raw});

  /// 解析后的业务数据。
  final T data;

  /// 原始响应体，方便业务方做调试或二次处理。
  final dynamic raw;

  @override
  T? get dataOrNull => data;
}

/// 失败响应。
class ApiError extends ApiResponse<Never> {
  /// 创建一个失败响应。
  const ApiError(this.message, {this.code, this.stackTrace});

  /// 错误信息。
  final String message;

  /// 错误码（HTTP 状态码或业务码）。
  final int? code;

  /// 堆栈信息。
  final StackTrace? stackTrace;

  @override
  Null get dataOrNull => null;
}

/// 当对 [ApiError] 调用 `ApiResponse.dataOrNull` 时不会抛出，
/// 该异常用于需要强制取数据的场景。
class ApiErrorException implements Exception {
  /// 创建一个 [ApiErrorException]。
  ApiErrorException(this.error);

  /// 底层错误对象。
  final ApiError error;

  @override
  String toString() => 'ApiErrorException: ${error.message}';
}
