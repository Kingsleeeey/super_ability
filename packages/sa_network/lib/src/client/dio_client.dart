import 'package:dio/dio.dart';
import 'package:sa_network/src/config/api_config.dart';
import 'package:sa_network/src/exceptions/api_exception.dart';
import 'package:sa_network/src/interceptors/log_interceptor.dart';
import 'package:sa_network/src/interceptors/null_param_interceptor.dart';
import 'package:sa_network/src/response/api_response.dart';

/// Dio 网络客户端。
///
/// 封装通用 HTTP 能力，业务码/数据解析完全交给业务方处理，
/// 网络库本身只负责网络层异常（超时、断网、HTTP 状态码等）。
class DioClient {
  /// 创建一个 [DioClient] 实例。
  DioClient({
    required ApiConfig config,
    List<Interceptor> interceptors = const [],
  }) : _dio = Dio(config.toBaseOptions()) {
    _dio.interceptors.addAll([
      NullParameterInterceptor(),
      ...interceptors,
      SaLogInterceptor(),
    ]);
  }

  final Dio _dio;

  /// 获取底层 Dio 实例。
  Dio get dio => _dio;

  /// 添加拦截器。
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// 通用请求。
  ///
  /// [parser] 用于将 Dio 原始响应解析为业务对象，不传则返回原始响应数据。
  Future<ApiResponse<T>> request<T>(
    String path, {
    required String method,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ApiResponseParser<T>? parser,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
        cancelToken: cancelToken,
      );
      return _parseResponse(response, parser);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// GET 请求。
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ApiResponseParser<T>? parser,
  }) {
    return request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      parser: parser,
    );
  }

  /// POST 请求。
  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ApiResponseParser<T>? parser,
  }) {
    return request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      parser: parser,
    );
  }

  /// PUT 请求。
  Future<ApiResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ApiResponseParser<T>? parser,
  }) {
    return request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      parser: parser,
    );
  }

  /// DELETE 请求。
  Future<ApiResponse<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ApiResponseParser<T>? parser,
  }) {
    return request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      parser: parser,
    );
  }

  ApiResponse<T> _parseResponse<T>(
    Response<dynamic> response,
    ApiResponseParser<T>? parser,
  ) {
    if (parser == null) {
      return ApiSuccess<T>(response.data as T, raw: response.data);
    }
    try {
      final data = parser.parse(response.data);
      return ApiSuccess<T>(data, raw: response.data);
    } on ApiException catch (e) {
      return ApiError(e.message, code: e.code, stackTrace: e.stackTrace);
    }
  }

  ApiException _handleDioError(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => TimeoutException(),
      DioExceptionType.badResponse => _handleBadResponse(error),
      DioExceptionType.connectionError => NetworkException(),
      DioExceptionType.cancel => ApiException('请求已取消'),
      DioExceptionType.badCertificate => ApiException('证书验证失败'),
      DioExceptionType.transformTimeout => TimeoutException(),
      DioExceptionType.unknown => ApiException('网络请求失败: ${error.message}'),
    };
  }

  ApiException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    return switch (statusCode) {
      401 => UnauthorizedException(),
      403 => ApiException('请求被拒绝', code: 403),
      404 => ApiException('请求资源不存在', code: 404),
      _ when statusCode != null && statusCode >= 500 => ServerException(),
      _ => ApiException(
        '请求失败: ${error.response?.statusMessage}',
        code: statusCode,
      ),
    };
  }
}
