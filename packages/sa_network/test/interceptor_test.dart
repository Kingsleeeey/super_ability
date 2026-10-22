import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_network/sa_network.dart';

class _FakeTokenProvider implements AuthTokenProvider {
  _FakeTokenProvider(this.token);

  final String? token;
  bool unauthorizedCalled = false;

  @override
  Future<String?> getToken() async => token;

  @override
  Future<void> onUnauthorized(
    DioException error,
    RequestOptions options,
  ) async {
    unauthorizedCalled = true;
  }
}

void main() {
  group('NullParameterInterceptor', () {
    test('过滤 query 中的 null 参数', () async {
      late RequestOptions captured;
      final adapter = _CallbackAdapter((options) {
        captured = options;
        return Response<dynamic>(
          requestOptions: options,
          data: 'ok',
          statusCode: 200,
        );
      });

      final dio = Dio()
        ..httpClientAdapter = adapter
        ..interceptors.add(NullParameterInterceptor());

      await dio.get<dynamic>(
        '/test',
        queryParameters: {'name': null, 'age': 18},
      );

      expect(captured.queryParameters, {'age': 18});
    });

    test('extra 中设置 sa_keep_null 时保留 null', () async {
      late RequestOptions captured;
      final adapter = _CallbackAdapter((options) {
        captured = options;
        return Response<dynamic>(
          requestOptions: options,
          data: 'ok',
          statusCode: 200,
        );
      });

      final dio = Dio()
        ..httpClientAdapter = adapter
        ..interceptors.add(NullParameterInterceptor());

      await dio.get<dynamic>(
        '/test',
        options: Options(extra: {'sa_keep_null': true}),
        queryParameters: {'name': null},
      );

      expect(captured.queryParameters, {'name': null});
    });
  });

  group('AuthInterceptor', () {
    test('有 token 时添加 Authorization 头', () async {
      late RequestOptions captured;
      final adapter = _CallbackAdapter((options) {
        captured = options;
        return Response<dynamic>(
          requestOptions: options,
          data: 'ok',
          statusCode: 200,
        );
      });

      final dio = Dio()
        ..httpClientAdapter = adapter
        ..interceptors.add(
          AuthInterceptor(provider: _FakeTokenProvider('abc123')),
        );

      await dio.get<dynamic>('/test');

      expect(captured.headers['Authorization'], 'Bearer abc123');
    });

    test('无 token 时不添加 Authorization 头', () async {
      late RequestOptions captured;
      final adapter = _CallbackAdapter((options) {
        captured = options;
        return Response<dynamic>(
          requestOptions: options,
          data: 'ok',
          statusCode: 200,
        );
      });

      final dio = Dio()
        ..httpClientAdapter = adapter
        ..interceptors.add(AuthInterceptor(provider: _FakeTokenProvider(null)));

      await dio.get<dynamic>('/test');

      expect(captured.headers.containsKey('Authorization'), isFalse);
    });
  });
}

/// 用于测试的 Dio HttpClientAdapter，直接返回预设 Response。
class _CallbackAdapter implements HttpClientAdapter {
  _CallbackAdapter(this.onFetch);

  final Response<dynamic> Function(RequestOptions options) onFetch;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    onFetch(options);
    return ResponseBody.fromString('ok', 200);
  }
}
