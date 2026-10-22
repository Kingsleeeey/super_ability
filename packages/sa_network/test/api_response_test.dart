import 'package:flutter_test/flutter_test.dart';
import 'package:sa_network/sa_network.dart';

class _UserParser extends ApiResponseParser<String> {
  @override
  String parse(dynamic data) {
    final map = data as Map<String, dynamic>;
    if (map['code'] == 0) {
      return map['data'] as String;
    }
    throw ApiException('业务码异常', code: map['code'] as int?);
  }
}

void main() {
  group('ApiResponse', () {
    test('ApiSuccess 返回数据', () {
      const response = ApiSuccess<String>('hello');
      expect(response.isSuccess, isTrue);
      expect(response.isError, isFalse);
      expect(response.dataOrNull, 'hello');
    });

    test('ApiError 不返回数据', () {
      const response = ApiError('失败', code: 500);
      expect(response.isSuccess, isFalse);
      expect(response.isError, isTrue);
      expect(response.dataOrNull, isNull);
    });
  });

  group('ApiResponseParser', () {
    test('解析成功业务数据', () {
      final parser = _UserParser();
      final result = parser.parse({'code': 0, 'data': '张三'});
      expect(result, '张三');
    });

    test('业务码非 0 时抛出 ApiException', () {
      final parser = _UserParser();
      expect(
        () => parser.parse({'code': 1001, 'data': null}),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
