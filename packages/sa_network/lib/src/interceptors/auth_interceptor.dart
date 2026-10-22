import 'package:dio/dio.dart';

/// 身份认证令牌提供者。
///
/// 业务方实现该接口，用于给请求统一添加 Token 或签名信息。
abstract class AuthTokenProvider {
  /// 获取当前访问令牌。
  ///
  /// 返回 null 表示未登录，不添加认证头。
  Future<String?> getToken();

  /// Token 过期或被踢出时的回调。
  ///
  /// 业务方可在该回调中刷新 Token、跳转登录页或清理本地登录态。
  Future<void> onUnauthorized(DioException error, RequestOptions options);
}

/// 自动附加认证令牌的拦截器。
class AuthInterceptor extends Interceptor {
  /// 创建一个 [AuthInterceptor]。
  AuthInterceptor({required this._provider});

  final AuthTokenProvider _provider;

  static const _authHeader = 'Authorization';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _provider.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers[_authHeader] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _provider.onUnauthorized(err, err.requestOptions);
    }
    handler.next(err);
  }
}
